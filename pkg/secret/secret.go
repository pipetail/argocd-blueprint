package secret

import (
	"encoding/json"
	"fmt"
	"io/ioutil"
	"net/http"
)

// Get obtains single secret from the DAPR API
func Get(port int, path string, key string) (string, error) {
	url := fmt.Sprintf("http://localhost:%d/%s", port, path)
	res, err := http.Get(url)
	if err != nil {
		return "", fmt.Errorf("could not get secret from DAPR API: %s", err)
	}
	defer res.Body.Close()

	// read secret body
	body, err := ioutil.ReadAll(res.Body)
	if err != nil {
		return "", fmt.Errorf("could not get secret body retreived from from DAPR API: %s", err)
	}

	// parse JSON
	var secrets map[string]string
	err = json.Unmarshal(body, &secrets)
	if err != nil {
		return "", fmt.Errorf("could not unmarshal JSON: %s", err)
	}

	// check if key exist
	if val, ok := secrets[key]; ok {
		return val, nil
	}

	return "", fmt.Errorf("key %s does not exist in received object", key)
}
