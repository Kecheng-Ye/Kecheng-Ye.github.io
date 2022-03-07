import fetch from "node-fetch";

export function template(strings, ...keys) {
  return function (...values) {
    let dict = values[values.length - 1] || {};
    let result = [strings[0]];
    keys.forEach(function (key, i) {
      let value = dict;
      key.split(".").forEach((one_key) => {
        if (!value.hasOwnProperty(one_key) || value[one_key] == undefined) {
          value = "N.A";
          return;
        }
        value = value[one_key];
      });

      result.push(value, strings[i + 1]);
    });
    return result.join("");
  };
}

export function createRequest(url, callback) {
  var xhr = new XMLHttpRequest();
  xhr.onreadystatechange = function () {
    if (xhr.readyState == 4 && xhr.status == 200)
      callback(JSON.parse(xhr.responseText));
  };
  xhr.open("GET", url, true);
  xhr.send(null);
  return xhr;
}

export async function fetch_and_process(url, post_process) {
  try {
    const response = await fetch(url);
    const json = await response.json();
    post_process(json);
    return json;
  } catch (error) {
    console.log(error.response.body);
  }
}

export const identity = (f) => f;
