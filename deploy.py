import json
from shutil import which
from solcx import compile_standard, install_solc
install_solc("v0.6.0")

with open("./SimpleStorage.sol","r") as file:
    simple_storage_file = file.read();
    print(simple_storage_file)

compiled_sol= compile_standard(
    {
    "language" : "Solidity",
    "sources": {"SimpleStorage.sol": {"content": simple_storage_file}},
    "settings":{
        "outputSelection":{
            "*": {"*": ["abi","metadata", "evm.bytecode", "evm.sourceMap"]}
        }
        
    },
   
 },
    solc_version="0.6.0",
)
with open("compiled_code.json","w") as file:
    json.dump(compiled_sol,file)


bytecode = compiled_sol["contracts"]["SimpleStorage.sol"]["SimpleStorage"]["evm"]["bytecode"]["object"]

abi =  compiled_sol["contracts"]["SimpleStorage.sol"]["SimpleStorage"]["abi"]

w3= Web3(Web3.HTTPProvider(""))


