package main

import (
	"flag"
	"fmt"
	"os"
)

func main() {
	ctx := flag.String("ctx", "", "input context to encrypt")
	key := flag.String("key", "", "input encrypt key")
	flag.Parse()
	if *ctx == "" {
		fmt.Println("input -ctx/-key xxx")
		os.Exit(1)
	}
	if *key == "" {
		*key = "deepglint"
	}
	len_ctx := len(*ctx)
	len_key := len(*key)
	ctx_enc := make([]byte, len_ctx)
	ctx_dec := make([]byte, len_ctx)
	for i := 0; i < len_ctx; i++ {
		ctx_enc[i] = (*ctx)[i] ^ (*key)[i%len_key]
	}
	for i := 0; i < len_ctx; i++ {
		ctx_dec[i] = ctx_enc[i] ^ (*key)[i%len_key]
	}
	fmt.Println("origin:", *ctx)
	fmt.Println("key:", *key)
	fmt.Println("encrypt:", ctx_enc)
	fmt.Println("decrypt:", string(ctx_dec))
}
