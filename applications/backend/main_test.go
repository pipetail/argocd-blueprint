package main

import "testing"

func TestPlus(t *testing.T) {
	res := plus(1, 2)
	if res != 3 {
		t.Errorf("plus(1, 1) = %d; want 3", res)
	}
}
