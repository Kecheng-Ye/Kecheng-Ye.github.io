export const UNDEFINED_STR = 'undefined';
export const UNDEFINED_NUM = -1;

export const trim_undefined = (value: any) => {
  return value == undefined ? 'undefined' : value;
};

export const round = (x: number, n: number) => {
  if (x == null) return 0;

  return Number(
    parseFloat(
      String(Math.round(x * Math.pow(10, n)) / Math.pow(10, n))
    ).toFixed(n)
  );
};

export const second = 1000;

export enum state {
  PENDING = 0,
  SUCCESS = 1,
  FAIL = 2,
}

export const trime = (max_size: number) => (input: string) => {
  if (input.length < max_size) {
    return input;
  } else {
    let result = input.substring(0, max_size - 3);
    result += '...';
    return result;
  }
};
