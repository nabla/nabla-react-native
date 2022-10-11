import { mergeVoid } from '../index';

describe('mergeVoid', () => {
  it('should call success', () => {
    // Given
    let calledSuccess = false
    // When
    mergeVoid(
      () => undefined,
      () => {},
      () => calledSuccess = true
    )(undefined)
    // Then
    expect(calledSuccess).toBeTruthy()
  })
})
