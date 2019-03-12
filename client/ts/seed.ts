export function getRandomInts (n: number): number[] {
  const { crypto } = window
  const randomInts = new Uint32Array(n)

  return Array.from(crypto.getRandomValues(randomInts))
}
