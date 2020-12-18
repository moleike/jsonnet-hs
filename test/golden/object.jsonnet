/*
Copyright 2015 Google Inc. All rights reserved.
Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at
    http://www.apache.org/licenses/LICENSE-2.0
Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/

std.assertEqual({}, {}) &&
std.assertEqual({ 'x': 1 }, { 'x': 1 }) &&
std.assertEqual({ '': 1 }, { '': 1 }) &&
std.assertEqual({ x: 1, y: 2 }.y, 2) &&
std.assertEqual({ x: 1, y: 2 }["y"], 2) &&
std.assertEqual({ x: error "foo", y: 2 }.y, 2) &&
// FIXME object composition not implemented
//std.assertEqual({ x: 1, y: 2 } + { z: 3 }, { x: 1, y: 2, z: 3 }) &&
//std.assertEqual({ x: 1, y: 2 } + { y: 3 }, { x: 1, y: 3 }) &&
//std.assertEqual({ x: 1, y: 2 } + { y+: 3 }, { x: 1, y: 5 }) &&
//std.assertEqual({ a: { x: 1 }, b: { x: 2 } } + { a+: { y: 3 }, b: { x: 3 } }, { a: { x: 1, y: 3 }, b: { x: 3 } }) &&

std.assertEqual({ x: 1, y: 2 } == { x: 1, y: 2 }, true) &&
std.assertEqual({ x: 1, y: 2 } == { x: 1, y: 2, z: 3 }, false) &&
std.assertEqual({ x: 1, y: 2 } != { x: 1, y: 2 }, false) &&
std.assertEqual({ x: 1, y: 2 } != { x: 1, y: 2, z: 3 }, true) &&

std.assertEqual({ f(x, y, z): x, y: self.f(1, 2, 3) }.y, 1) &&
//std.assertEqual({ ["f"](x, y, z):: x, "y"(x): self.f(x, 2, 3), z: self.y(4) }.z, 4) &&

// Object Local

std.assertEqual({ local foo = 3, local bar(n) = foo + n, x: foo, y: foo + bar(1) }, { x: 3, y: 7 }) &&
std.assertEqual({ local foo = bar(3)[1], local bar(n) = [foo, n], x: foo, y: [foo] + bar(3) }, { x: 3, y: [3, 3, 3] }) &&

// Computed field name
std.assertEqual(local f = "x"; { [f]: 1 }, { x: 1 }) &&
std.assertEqual({ [pair[0]]: pair[1] for pair in [["x", 1], ["y", 2]] }, { x: 1, y: 2 }) &&
std.assertEqual(local t = { a: 1, b: 2, c: null, d: 4 }; { [x]: t[x] for x in [y for y in ["a", "b", "c", "d"] if t[y] != null] }, { a: 1, b: 2, d: 4 }) &&

// Comprehension object

std.assertEqual(local x = 10; { ["" + x]: x for x in [x, x + 1, x + 2] }, { "10": 10, "11": 11, "12": 12 }) &&

// FIXME keys should not have in scope object local bindings
//std.assertEqual(local x = "foo"; { local x = "bar", [x]: 1 }, { foo: 1 }) &&
// FIXME '$' binding to uppermost object is not defined in an object comprehension
//std.assertEqual({ [x + ""]: if x == 1 then 1 else x + $["1"] for x in [1, 2, 3] }, { "1": 1, "2": 3, "3": 4 }) &&

std.assertEqual(local x = "baz"; { local x = "bar", [x]: x for x in ["foo"] }, { foo: "bar" }) &&


// TODO we replaced `self` with `$` (?)
std.assertEqual({ f: "foo", g: { [$.f]: 7 } }, { f: "foo", g: { foo: 7 } }) &&

std.assertEqual({ [k]: null for k in [] }, {}) &&
std.assertEqual({ [null]: "test" for k in [1] }, {}) &&
std.assertEqual({ [null]: "test" }, {}) &&

std.assertEqual({ ["" + k]: k for k in [1, 2, 3] }, { "1": 1, "2": 2, "3": 3 }) &&
std.assertEqual({ ["" + (k + 1)]: (k + 1) for k in [0, 1, 2] }, { ["" + k]: k for k in [1, 2, 3] }) &&
std.assertEqual({ ["" + k]: k for k in [1, 2, 3] }, { "1": 1, "2": 2, "3": 3 }) &&
std.assertEqual({ [x + ""]: x + foo, local foo = 3 for x in [1, 2, 3] }, { "1": 4, "2": 5, "3": 6 }) &&

local obj = {
    f14true: { x: 1, y: 4, z: true },
    f14false: { x: 1, y: 4, z: false },
    f16true: { x: 1, y: 6, z: true },
    f16false: { x: 1, y: 6, z: false },
    f26true: { x: 2, y: 6, z: true },
    f26false: { x: 2, y: 6, z: false },
    f36true: { x: 3, y: 6, z: true },
    f36false: { x: 3, y: 6, z: false },
};

std.assertEqual(obj, { ["f" + x + y + z]: { x: x, y: y, z: z } for x in [1, 2, 3] for y in [1, 4, 6] if x + 2 < y for z in [true, false] }) &&

std.assertEqual({ local foo(x) = self.y + x, x: foo(5), y:: 5 }, { x: 10 }) &&

true
