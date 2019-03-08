import { getRandomInts } from './seed'

describe('seed random number generator module', () => {
  it('generate an array of n random numbers', () => {
    const numberOfInts = 3
    const randomInts = getRandomInts(numberOfInts)
    expect(randomInts.length).toBe(numberOfInts)
  })
})
