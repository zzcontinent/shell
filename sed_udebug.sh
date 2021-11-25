#!/bin/bash
sed -i 's/^{/{\n\tudebug(\"\\r\\n\");/g' $@
