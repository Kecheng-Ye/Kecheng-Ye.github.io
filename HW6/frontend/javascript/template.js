export default function template(strings, ...keys) {
  return (function(...values) {
    let dict = values[values.length - 1] || {};
    let result = [strings[0]];
    keys.forEach(function(key, i) {
      let value = dict
      key.split(".").forEach((one_key) => {
        value = value[one_key]
      })

      result.push(value, strings[i + 1]);
    });
    return result.join('');
  });
}

