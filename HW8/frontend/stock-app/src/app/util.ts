export const UNDEFINED_STR = 'undefined';
export const UNDEFINED_NUM = -1;

export const trim_undefined = (value: any) => {
  return value == undefined ? 'undefined' : value;
};

export const round = (x: number, n: number) =>
  Number(
    parseFloat(
      String(Math.round(x * Math.pow(10, n)) / Math.pow(10, n))
    ).toFixed(n)
  );
