/*
© Copyright IBM Corporation 2017

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

http://www.apache.org/licenses/LICENSE_2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
*/
package main

import (
	"os"
	"testing"
)

var licenseTests = []struct {
	in  string
	out string
}{
	{"en_US.UTF_8", "English.txt"},
	{"en_US.ISO-8859-15", "English.txt"},
	{"en", "English.txt"},	
	{"en_US", "English.txt"},
}

func TestResolveLicenseFile(t *testing.T) {
	for _, table := range licenseTests {
		os.Setenv("LANG", table.in)
		f := resolveLicenseFile()
		if f != table.out {
			t.Errorf("resolveLicenseFile() with LANG=%v - expected %v, got %v", table.in, table.out, f)
		}
	}
}
