




-Og -g3 \
\
-D_FORTIFY_SOURCE=2 \
-D_GLIBCXX_DEBUG \

-fcf-protection=full \

-fharden-compares
-fharden-conditional-branches

-fstack-check
-fstack-clash-protection
-fstack-protector-all \
-ftrapv \
-ftrivial-auto-var-init=pattern
