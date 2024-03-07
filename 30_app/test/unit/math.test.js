const math = require("../../src/lib/math/math.js");

describe("library math", () => {
  it("padding of '0.5' is '0.500'", () => {
    expect(math.padding(0.5)).toBe("0.500");
  });

  it("padding of 'null' is '-'", () => {
    expect(math.padding(null)).toBe("-");
  });

  it("round of '0.015' is '0.02'", () => {
    expect(math.round(0.015)).toBe(0.02);
  });
});

