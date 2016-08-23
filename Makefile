BUILD_DIR = web/js/compiled/
OUTPUT = $(BUILD_DIR)code.js
SOLC = web/node_modules/.bin/solcjs
CONTRACTS = $(addprefix contracts/, $(addsuffix .sol, \
			UnanimousConsent CallLib BulletinBoard CompareOp Adjudicator Rules NonceCompareOp ECDSASignatureProxy \
			))

.PHONY: abin clean

$(OUTPUT) : abin
	> $(OUTPUT)
	for f in $(BUILD_DIR)*.abi; do \
		printf "var %s_ABI = %s;\n" "$$(basename $$f | cut -d. -f1 | tr a-z A-Z)" "$$(cat $$f)" >> $(OUTPUT); \
		done;
	for f in $(BUILD_DIR)*.bin; do \
		printf "var %s_BIN = \"%s\";\n" "$$(basename $$f | cut -d. -f1 | tr a-z A-Z)" "$$(cat $$f)" >> $(OUTPUT); \
		done;
	rm $(BUILD_DIR)*.abi $(BUILD_DIR)*.bin

abin : | $(SOLC) $(BUILD_DIR)
	 $(SOLC) --abi --bin --output-dir $(BUILD_DIR) $(CONTRACTS)

$(SOLC) :
	cd web/ && npm install

$(BUILD_DIR) :
	mkdir $(BUILD_DIR)

clean :
	rm -rf $(BUILD_DIR)
