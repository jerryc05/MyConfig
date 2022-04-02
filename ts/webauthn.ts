const attestation: AttestationConveyancePreference | undefined = 'indirect'  // default 'none', recognizes 'fido-u2f', 'tpm', 'apple' ...
const authenticatorSelection: AuthenticatorSelectionCriteria = {
  authenticatorAttachment: undefined,  // [authenticatorAttachment] tries 'platform' first, and then 'cross-platform', if has [PKCS1] alg
  requireResidentKey: true,
  userVerification: 'preferred',
}
const challenge: Uint8Array = new TextEncoder().encode('randomStringFromServer, need to prevent replay attacks')
const excludeCredentials: PublicKeyCredentialDescriptor[] | undefined = undefined
const extensions: AuthenticationExtensionsClientInputs | undefined = undefined
const pubKeyCredParams: PublicKeyCredentialParameters[] = [
  /*  */-8,  // EdDSA
  /*  */-7,  // ECDSA w/ SHA-256
  /* */-47,  // ECDSA using secp256k1 curve and SHA-256
  /* */-35,  // ECDSA w/ SHA-384
  /* */-36,  // ECDSA w/ SHA-512
  /*   */1,  // AES-GCM w/ 128-bit key
  /*   */2,  // AES-GCM w/ 192-bit key
  /*   */3,  // AES-GCM w/ 256-bit key
  /*  */24,  // ChaCha20/Poly1305 w/ 256-bit key
  /**/-257,  // RSASSA-PKCS1-v1_5 using SHA-256, check [authenticatorAttachment]
  /**/-258,  // RSASSA-PKCS1-v1_5 using SHA-384
  /**/-259,  // RSASSA-PKCS1-v1_5 using SHA-512
].map(alg => ({ alg: alg, type: 'public-key' }))
const rp: PublicKeyCredentialRpEntity = {
  name: "jerryc05's Server",
  // id: 'https://example.com',  // If omitted, its value will be the CredentialsContainer object’s relevant settings object's origin's effective domain.
}
const timeout: number = 30 * 1000  // in milliseconds
const user: PublicKeyCredentialUserEntity = {
  id: new TextEncoder().encode('user id here'),
  name: 'jerryc05@example.com',
  displayName: 'jerryc05',
}

const publicKey: PublicKeyCredentialCreationOptions = {
  attestation,
  authenticatorSelection,
  challenge,
  excludeCredentials,
  extensions,
  pubKeyCredParams,
  rp,
  timeout,
  user,
}

const signal: AbortSignal | undefined = undefined

navigator.credentials.create(
  { publicKey, signal }
).then(credential => { })
