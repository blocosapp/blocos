module.exports = {
  clearMocks: true,
  coverageDirectory: "coverage",
  globals: {
    'ts-jest': {
      tsConfig: 'server.tsconfig.json'
    }
  },
  moduleFileExtensions: ['elm', 'js', 'ts'],
  preset: 'ts-jest',
  setupFiles: ['./jest.boot.js']
}
