/*
 * A simple Copy On Write (COW) string implementation.
 *
 * Copyright Â© 2014 Manu Sanchez. @Manu343726 on GitHub, Stack Overflow, etc.
 *
 * manu343726.github.io
 *
 * This program is free software. It comes without any warranty, to
 * the extent permitted by applicable law. You can redistribute it
 * and/or modify it under the terms of the Do What The Fuck You Want
 * To Public License, Version 2, as published by Sam Hocevar. See
 * http://www.wtfpl.net/ for more details.
 */

/*
 * Just for the sake of learning, here is an article showing how real C++
 * works on this topic: http://www.drdobbs.com/generic-a-policy-based-basicstring-imple/184403784
 * The implementation provided here is only a simple proof of concept of a COW string. There is no
 * allocator nor storage policy, only a COW string using raw new/deletes (Or even no ones, since current
 * C++ encourages avoiding such, in favor of automatic storage duration and RAII-based memory resources).
 *
 * Besides the Modern-C++-uses-no-new/delete-at-all debate, the point of this implementation is to show that
 * simple string implementations (Counter + dynamic char buffer) are never used in the real world since
 * they permorm very poorly (Many undesired and unneccesary allocations), and many approaches (optimizations) were
 * developed to solve these problems.
 * The Copy On Write approach is a widely used pattern based on the fact that in the most common situations we are only working
 * with a "view" of the original thing (A string in this case), so a copy is not necessary.
 *
 * Consider this example:
 *
 *     std::string hello_world = "hello world";
 *     std::string hello       = hello_world.substr(0 , 5);
 *
 *     std::cout << "Say " << hello << "to the world!" << std::endl;
 *
 * We define hello as a substring of hello_world, but we are not mutating hello at all, so making a copy is not really needed.
 * Instead, the most efficient way to achieve this is to return a view to that part of the string, where a "view" is something that
 * behaves like a string, but is a thing that uses data not of its own, but from others (hello_world in the example) instead.
 * This kind of thing is very common in the programming world, from simple views like this to lazy computational pipelines. The point is: Don't create
 * new data, use the original storing some kind of transformation. When the view is accessed, apply the transform. This lazy evaluation is much more efficient
 * than using more memory in general (Is not a matter of memory space but memory access. See a good keynote on this topic here: https://www.youtube.com/watch?v=3-ieS3SGFzo).
 * Modern computers are memory bounded, not CPU bounded.
 *
 * The example above is completely real (I'm not good at writting examples, so I usually use real cases ;) ), see the std::string_view Technical Specification for
 * C++17 here: http://en.cppreference.com/w/cpp/header/experimental/string_view
 *
 * Ok, we can avoid copies when viewing strings in a non-mutable way, which is much more cool and efficient than creating a new string. So, how this situation looks
 * like under the hood?:
 *
 * Here at the stack frame of our function              somewhere in the free store
 *
 * hello_world
 * +-------------------------------+
 * | char* _buff ------------------|-----------...--------> "hello world!"
 * | std::size_t _size , _capacity |                        ^
 * +-------------------------------+                        |
 *                                                          |
 * hello                                                    |
 * +-------------------------------+                        |
 * | char* _i_don't_own_this_buff -|-----------...----------
 * | std::size_t _begin , _end     |
 * +-------------------------------+
 *
 * As I said previously, hello doesn't have its own char buffer, but references the one from hello_world. But what happens if we do a mutable operation on hello?:
 *
 *     hello[0] = j; //What happens here?
 *     hello[4] = y;
 *
 * We don't want hello_world containning "jello world!" isn't? Then we should stop referencing the hello_world buffer and create our own for hello. In other words,
 * we should Copy when we Write. Welcome to COW!
 *
 * Here at the stack frame of our function              somewhere in the free store
 *
 * hello_world
 * +-------------------------------+
 * | char* _buff ------------------|-----------...--------> "hello world!"
 * | std::size_t _size , _capacity |
 * +-------------------------------+
 *
 * hello
 * +-------------------------------+
 * | char* _now_i_have_my_own_buff-|-----------...--------> "jelly"
 * | std::size_t _begin , _end     |
 * +-------------------------------+
 *
 * Note that if you don't implement COW correctly you will lead into a jelly world. Whats better, a correct COW or a bug?
 */

/*
* THE IMPLEMENTATION
* ==================
*
* I'm a big fan of The Rule Of Zero, it encourages safe resource management and simplifies C++ classes a lot.
* Since the purpose of this code is only illustrative, and real-world performance is not one of the goals here,
* I will use a std::vector<char> as buffer and a std::shared_ptr to do ref counting on that buffer. That could be
* inefficient (The vector is dynamically allocated, which makes no much sense), but using a container is much more simple
* than the alternative of reinventing the wheel managing the array and its allocation/reallocation. The point of this example
* is to learn COW, not memory management. Refer to edalib's Vector for that.
*
* The approach taken in the real-world, commonly the struct-hack to avoid double memory allocation, requires depth understanding
* of the C++ runtime and language, memory alignment, etc; things far away from the skills and objectives of EDA. So using Standard Library
* features seems reasonable to keep the example clear. Also following the Rule Of Zero is A Good Thing always, except in some rare cases
* where it could lead into unexpected performance hits, like this case. Let's be clear, forget performance.
*
* IF(YOU ARE A C++ GURU) GOTO CODE BELLOW
*
* But what is The Rule Of Zero?
* First you should understand the semantics of C++ objects: C++ uses value semantics by default, in contrast with languages like Java where
* the default is to do reference semantics: In Java what you manipulate is a reference to the object instead of the object itself, so copying
* your variable becomes moving around the reference letting the object untouched. The same for assignment, swapping (Try to write a swap function in
* Java ;) ), etc.
* In C++ your variable IS the object. If your variable is local to a function, the object is local to that function and lives in the stack frame of
* that function. No garbage collection is needed, since you are working with the object directly and that object has a clear lifetime, its scope.
*
* C++ objects are designed to manipulate/represent/own a resource, where a resource could be a file, a dynamic array, a socket connection, a mutex, etc.
* The object manages that resource, which is exactly the inverse of what Java does: Java gives you the pointer to the resource, and that pointer is managed
* by the GC. C++ gives you an object, which manages a resource, and that object has a clear and deterministic lifetime. In C++ a resource is not leaked because
* its bounded to an object with a lifetime and that object performs actions automatically when its lifetime starts and ends: That are constructors and destructors.
* A constructor initializes the resource managed by the object, and the destructor releases it. In that way, its impossible to leave open a file in C++, for example.
* The file is managed by an object which destructor will be called even if an exception is thrown, and the destructor will close and release the file.
* This is known as RAII (Resource Acquisition Is Initialization).
*
* All that cool and safe machinery comes at a cost: Its hard to deep understand and implement C++ object semantics correctly. We should move around the managed resources between
* objects when they (the objects) are copied, assigned, moved, etc. In Java the variable-pointer is copied around while the object still remains in the same location. In C++
* the objects are fixed at their location and are the resources managed by that objects which fly away along your program.
* The C++ approach may appear inefficient compared to the Java "only copy pointers" approach, but all that memory indirection in Java (Remember the modern memory bounded systems we have),
* and the GC overhead becomes the sources of a poor performance in general. But that's another debate.
*
* The fact is that the way C++ manages resources through objects using value semantics leads into the following rules:
*
* - To initialize an object means to initialize its internal managed resource. This is what the ctor does.
* - To copy an object means to copy the resource managed by the old object and own it in the new object. This is what the copy constructor (I feel better to call it "lvalue ctor", meaning "Initialize from lvalue") does.
* - [SINCE C++11] To move an object means to stole the resource managed by the old object and own it in the new object. This is what the move ctor (I feel better to call it "rvalue ctor", meaning "Initialize from rvalue") does.
* - To assign an object means to copy the resource from the assigned object, release our current resource, and then own the copied resource. This is what the assignment operator does. Again, I feel that "lvalue assignment" is
*   a better name.
* - [SINCE C++11] To move-assign an object means to stole the resource from the assigned object, release our current resource, and then own the resource we have taken. This is what the move-assignment operator does. Again, I feel
*   that "rvalue assignment" is a better name.
*
* Each one of this five rules (Three until C++11) are tightly coupled to the rest, and implementing them correctly could be a hard job. Even if the C++ compiler provides implementations for all that rules by default (i.e. it provides
* a default implementation for the ctors, dtor, and assignment operators) if you override the default implementation semantics in any way, say providing your own copy ctor, the complete semantics are not uniform nor guaranteed, so the
* compiler will not generate the default implementations and you will have to do the five/three by hand. This is known in the C++ community as "The Rule Of Three/Five".
*
* Since those rules are hard to follow, modern C++ encourages the use of Standard Library facilities such as containers, streams, mutexes, etc; to deal with resource management. If you don't own naked resources but use resources
* though the Standard Library you don't have to override the default semantics provided by the compiler. So you don't have to write copy/move ctors, assignment operators, dtors, etc. The Rule Of Zero.
*
*
*
* Finally note that COW strings are not supported since C++11, because the Standard specifies that only mutable operations should invalidate iterators
* and pointers (Those are invalidated since a detach similar to what this example does is performed). But calls to data() (The function which returns
* a pointer to the underlying storage) do detaching too, since the underlying storage is provided to the user and we don't want to modify multiple
* strings touching only a buffer provided by a unique data() call. This behavior is invalid in the current Standard, so COW implementations are disallowed.
* Note that means that GCC is a non-standard compliant compiler, since libstdc++ implements std::basic_string using COW: https://gcc.gnu.org/onlinedocs/gcc-4.6.2/libstdc++/api/a00770_source.html
* They don't want to break their ABI, etc. Microsoft's MSVC (The Visual Studio C++ compiler) does SSO (Short string optimization) which performs better on modern multithreaded CPUs (But performs
* poorly on move semantics, since copying and moving becomes almost the same for little strings. ). I'm not aware of what LLVM's libc++ for CLang does.
*/

#include <memory>
#include <algorithm>
#include <vector>
#include <stdexcept>
#include <iostream>

/*
 * Note that this string wasn't tested, its only a proof of concept. Anyway, contact me if you have any issue with this.
 * Check my website above for contact.
 */

template<class CHAR , bool debug = false>
struct cowbasic_string
{
public:
    //Default ctor
    cowbasic_string() :
        _shared_buff{ std::make_shared<storage>() }, //Zero length buffer by default.
        _begin{0},
        _end{0}
    {}

    //A constructor to initialize our strings with string literals
    template<std::size_t N>
    explicit cowbasic_string( const CHAR (&string_literal)[N] ) : _shared_buff{ std::make_shared<storage>( N-1 ) }, //-1 since we don't store the null terminator
        _begin{0},
        _end{N-2}
    {
        std::copy( std::begin(string_literal) , std::end(string_literal) - 1 ,
                   _shared_buff->begin() );
    }

    //A constructor to generate views of (sub)strings:
    cowbasic_string( const cowbasic_string& other , std::size_t begin , std::size_t end ) : //Note the user is responsible of passing the right indices (Indices from the buffer perspective not the string one) using the
        cowbasic_string{ other } //Call copy ctor                                             required offset() calls on their parent string.
    {
        _begin = begin;
        _end = end;
    }




  //Some string ops

  //Returns a substring of this string given the range [begin,end] of characters
  cowbasic_string substr( std::size_t begin , std::size_t end )
  {
      if( begin > end ) throw std::invalid_argument{ "cowbasic_string::substr(): The substring has range [begin,end]. End should be greater or equal to begin" };

      //Begin and end are indices relative to the string, not the underlying storage.
      //Suppose our string is "world", but our string is really a substring of another "hello world"
      //string:
      //
      // Shared storage: "hello world"
      //                        <--->
      //                      Our string
      //
      //That means the character at position 0 of our string is really the character at position 6
      //on the storage. The _begin and _end members of cowbasic_string are relative to the storage,
      //so we should apply the offset to the indices the user passed to us.

      return cowbasic_string{ *this , begin + offset() , end + offset() };
  }


    //Does no bounds-checked read access to a character of the string
    CHAR operator[]( std::size_t index ) const
    {
        return (*_shared_buff)[index + offset()];
    }

    //Does no bounds-checked write access to a character of the string
    CHAR& operator[]( std::size_t index )
    {
        _detach(); //This is a mutable op, so detach from the source string first
        return (*_shared_buff)[index + offset()];
    }

    //Does bounds-checked read access to a character of the string
    CHAR at( std::size_t index ) const
    {
        if( index < size() )
            return (*this)[index];
        else
            throw std::out_of_range{"cowbasic_string::at() (READ): Index out of range"};
    }

    //Does bounds-checked write access to a character of the string
    CHAR& at( std::size_t index )
    {
        if( index < size() )
            return (*this)[index];
        else
            throw std::out_of_range{"cowbasic_string::at() (WRITE): Index out of range"};
    }

    //Returns the offset from the beginning of the storage to the beginning of this string
    std::size_t offset() const
    {
        return _begin;
    }

    //Returns the size (Length) of this string
    std::size_t size() const
    {
        return _end - _begin + 1;
    }

    //Returns the start address of the string (Only for debugging purposes, don't use it!)
    void* start_addr() const
    {
        return static_cast<void*>(&(*_shared_buff)[offset()]);
    }

    //Prints our strings to C++ streams. Use it to overload std::to_string() or explicit to std::string conversion if you like.
    friend std::ostream& operator<<( std::ostream& os , const cowbasic_string& str )
    {
        for( std::size_t i = 0 ; i < str.size() ; ++i )
            os << str[i];

        return os << '\0';
    }
private:
    using storage = std::vector<CHAR>;

    std::shared_ptr<storage> _shared_buff; //Note that std::shared_ptr is thread safe, so making a thread safe implementation of this could be easier than in the old days.
                                           //Enter atomics and say goodbye to lock-based concurrent programming! https://www.youtube.com/watch?v=CmxkPChOcvw (std::smart_ptr has an internal mutex, is not atomic yet :( )

    std::size_t _begin , _end; //Range of characters of the buffer which this string has. This is why we don't store the null terminator, because its added explicitly later in all cases, to take care of middle ranges.

    //Detach this string from the original and create a buffer for its own.
    void _detach()
    {
        if( _shared_buff.unique() ) return; //If this string is the only viewing the buffer the detach is not needed.

        const storage& old = *_shared_buff;
        _shared_buff.reset( new storage(_end - _begin , ' ') ); //Be careful with uniform initialization and narrowing conversions here

        std::copy( old.begin() + _begin , old.begin() + _end ,
                   _shared_buff->begin() );

        //Never use an ugly preprocesor if for something you can do with a simple and readable compile-time if
        if(debug)
            std::cout << "Detach done" << std::endl;
    }
};


using cowstring = cowbasic_string<char>;
using debug_cowstring = cowbasic_string<char,true>;


int main()
{
    debug_cowstring hello_world{"hello world"};
    auto hello = hello_world.substr(0,4);
    auto world = hello_world.substr(6,10);

    std::cout << hello_world << std::endl
              << hello << std::endl
              << world << std::endl; //Ok Freire, one point for C: printf() formatting...

    std::cout << "hello_world start address: " << hello_world.start_addr() << std::endl
              << "hello start address:       " << hello.start_addr()       << std::endl
              << "world start address:       " << world.start_addr()       << std::endl;


    hello[0] = 'j';
    hello[4] = 'y';

    std::cout << hello_world << std::endl
              << hello << std::endl
              << world << std::endl;

    std::cout << "hello_world start address: " << hello_world.start_addr() << std::endl
              << "hello start address:       " << hello.start_addr()       << std::endl
              << "world start address:       " << world.start_addr()       << std::endl;
}
