pragma solidity 0.8.19;

/// @notice How are initial values and immutable variables set in the initialisation code?
///     Answer: immutable variables are copied to the runtime code when the creation
///     code is executed
///     TODO: make the analysis for initial values of state variables
contract ImmutableVars {
    uint256 public immutable state;

    constructor(uint256 _state) {
        state = _state;
    }
}

/*
I have compiled the code with the commands specified below, and used evm.codes
to run step by step through the execution. I will probably write a more
detailed article about this, but here are some highlights:

- The constructor parameter `_state` has to be appended to the creation
    code in the `data` field of the transaction
- The creation code checks if the parameter was passed to the constructor by
    copying to memory the bytes that come after the initialization code
    (instruction `[1f]`) and checking that it is not empty (instructions `[82]`,
    `[83]` and `[84]`). If no data was supplied, then the contract reverts
- If the parameter is passed, it is stored in memory at position 0x80 (
    instruction `[38]`)
- All the runtime code is copied to memory (instruction `[b3]`)
- The bytes 73 to 104 (which are all zeros initialy in the runtime code) are
    updated with the parameter passed that was stored in memory (instruction
    `[b9]`)
- The runtime code is returned in instructon `[b9]`
- The immutable variable is not stored in storage it is stored in the account
    code, that is why it is cheaper than a state variable

[Link to evm.codes](https://www.evm.codes/playground?fork=shanghai&unit=Wei&codeType=Bytecode&code='va0iy10ks1lmb3q3qlmb8339pp01s2p0ty329ty7bzqvqpp52_uya8zxny58py45zp14y63kzrp5Zy75py4fzoj840312my9m7ygy40zhry9f84828u1y66z91_ozvq51v9byc0r39rv4gm2v9brf3fevqiv0fkv043lv2857r35ve01cq63c19d93fb14v2d57hxv33v47zs1v3e9tv82zs1q9103gf3h7fYY~0pznv7cpv6bz8252_j0Zv95r830184v75zo56YY002a'~000z56hyl0xrqfdhw~~~~~v60u50t1gsv405r6~q80p81o9291_nr8Z9Zzm15l610k57xujzrv2082is234qmh5bg90_uuZtuYww%01YZ_ghijklmnopqrstuvwxyz~_)

Compiled creation code using `solc --bin --no-cbor-metadata src/ImmutableVars.sol`:
```
60a060405234801561001057600080fd5b5060405161015b38038061015b8339818101604052810190610032919061007b565b8060808181525050506100a8565b600080fd5b6000819050919050565b61005881610045565b811461006357600080fd5b50565b6000815190506100758161004f565b92915050565b60006020828403121561009157610090610040565b5b600061009f84828501610066565b91505092915050565b608051609b6100c0600039600060490152609b6000f3fe6080604052348015600f57600080fd5b506004361060285760003560e01c8063c19d93fb14602d575b600080fd5b60336047565b604051603e91906082565b60405180910390f35b7f000000000000000000000000000000000000000000000000000000000000000081565b6000819050919050565b607c81606b565b82525050565b6000602082019050609560008301846075565b9291505056
```

Compiled runtime code using `solc --bin-runtime --no-cbor-metadata src/ImmutableVars.sol`:
```
6080604052348015600f57600080fd5b506004361060285760003560e01c8063c19d93fb14602d575b600080fd5b60336047565b604051603e91906082565b60405180910390f35b7f000000000000000000000000000000000000000000000000000000000000000081565b6000819050919050565b607c81606b565b82525050565b6000602082019050609560008301846075565b9291505056
```

Creation code with mnemonics:
```
[00]    PUSH1   a0
[02]    PUSH1   40
[04]    MSTORE  
[05]    CALLVALUE   
[06]    DUP1    
[07]    ISZERO  
[08]    PUSH2   0010
[0b]    JUMPI   
[0c]    PUSH1   00
[0e]    DUP1    
[0f]    REVERT  
[10]    JUMPDEST    
[11]    POP 
[12]    PUSH1   40
[14]    MLOAD   
[15]    PUSH2   015b
[18]    CODESIZE    
[19]    SUB 
[1a]    DUP1    
[1b]    PUSH2   015b
[1e]    DUP4    
[1f]    CODECOPY    
[20]    DUP2    
[21]    DUP2    
[22]    ADD 
[23]    PUSH1   40
[25]    MSTORE  
[26]    DUP2    
[27]    ADD 
[28]    SWAP1   
[29]    PUSH2   0032
[2c]    SWAP2   
[2d]    SWAP1   
[2e]    PUSH2   007b
[31]    JUMP    
[32]    JUMPDEST    
[33]    DUP1    
[34]    PUSH1   80
[36]    DUP2    
[37]    DUP2    
[38]    MSTORE  
[39]    POP 
[3a]    POP 
[3b]    POP 
[3c]    PUSH2   00a8
[3f]    JUMP    
[40]    JUMPDEST    
[41]    PUSH1   00
[43]    DUP1    
[44]    REVERT  
[45]    JUMPDEST    
[46]    PUSH1   00
[48]    DUP2    
[49]    SWAP1   
[4a]    POP 
[4b]    SWAP2   
[4c]    SWAP1   
[4d]    POP 
[4e]    JUMP    
[4f]    JUMPDEST    
[50]    PUSH2   0058
[53]    DUP2    
[54]    PUSH2   0045
[57]    JUMP    
[58]    JUMPDEST    
[59]    DUP2    
[5a]    EQ  
[5b]    PUSH2   0063
[5e]    JUMPI   
[5f]    PUSH1   00
[61]    DUP1    
[62]    REVERT  
[63]    JUMPDEST    
[64]    POP 
[65]    JUMP    
[66]    JUMPDEST    
[67]    PUSH1   00
[69]    DUP2    
[6a]    MLOAD   
[6b]    SWAP1   
[6c]    POP 
[6d]    PUSH2   0075
[70]    DUP2    
[71]    PUSH2   004f
[74]    JUMP    
[75]    JUMPDEST    
[76]    SWAP3   
[77]    SWAP2   
[78]    POP 
[79]    POP 
[7a]    JUMP    
[7b]    JUMPDEST    
[7c]    PUSH1   00
[7e]    PUSH1   20
[80]    DUP3    
[81]    DUP5    
[82]    SUB 
[83]    SLT 
[84]    ISZERO  
[85]    PUSH2   0091
[88]    JUMPI   
[89]    PUSH2   0090
[8c]    PUSH2   0040
[8f]    JUMP    
[90]    JUMPDEST    
[91]    JUMPDEST    
[92]    PUSH1   00
[94]    PUSH2   009f
[97]    DUP5    
[98]    DUP3    
[99]    DUP6    
[9a]    ADD 
[9b]    PUSH2   0066
[9e]    JUMP    
[9f]    JUMPDEST    
[a0]    SWAP2   
[a1]    POP 
[a2]    POP 
[a3]    SWAP3   
[a4]    SWAP2   
[a5]    POP 
[a6]    POP 
[a7]    JUMP    
[a8]    JUMPDEST    
[a9]    PUSH1   80
[ab]    MLOAD   
[ac]    PUSH1   9b
[ae]    PUSH2   00c0
[b1]    PUSH1   00
[b3]    CODECOPY    
[b4]    PUSH1   00
[b6]    PUSH1   49
[b8]    ADD 
[b9]    MSTORE  
[ba]    PUSH1   9b
[bc]    PUSH1   00
[be]    RETURN  
[bf]    INVALID 
[c0]    PUSH1   80
[c2]    PUSH1   40
[c4]    MSTORE  
[c5]    CALLVALUE   
[c6]    DUP1    
[c7]    ISZERO  
[c8]    PUSH1   0f
[ca]    JUMPI   
[cb]    PUSH1   00
[cd]    DUP1    
[ce]    REVERT  
[cf]    JUMPDEST    
[d0]    POP 
[d1]    PUSH1   04
[d3]    CALLDATASIZE    
[d4]    LT  
[d5]    PUSH1   28
[d7]    JUMPI   
[d8]    PUSH1   00
[da]    CALLDATALOAD    
[db]    PUSH1   e0
[dd]    SHR 
[de]    DUP1    
[df]    PUSH4   c19d93fb
[e4]    EQ  
[e5]    PUSH1   2d
[e7]    JUMPI   
[e8]    JUMPDEST    
[e9]    PUSH1   00
[eb]    DUP1    
[ec]    REVERT  
[ed]    JUMPDEST    
[ee]    PUSH1   33
[f0]    PUSH1   47
[f2]    JUMP    
[f3]    JUMPDEST    
[f4]    PUSH1   40
[f6]    MLOAD   
[f7]    PUSH1   3e
[f9]    SWAP2   
[fa]    SWAP1   
[fb]    PUSH1   82
[fd]    JUMP    
[fe]    JUMPDEST    
[ff]    PUSH1   40
[101]   MLOAD   
[102]   DUP1    
[103]   SWAP2   
[104]   SUB 
[105]   SWAP1   
[106]   RETURN  
[107]   JUMPDEST    
[108]   PUSH32  0000000000000000000000000000000000000000000000000000000000000000
[129]   DUP2    
[12a]   JUMP    
[12b]   JUMPDEST    
[12c]   PUSH1   00
[12e]   DUP2    
[12f]   SWAP1   
[130]   POP 
[131]   SWAP2   
[132]   SWAP1   
[133]   POP 
[134]   JUMP    
[135]   JUMPDEST    
[136]   PUSH1   7c
[138]   DUP2    
[139]   PUSH1   6b
[13b]   JUMP    
[13c]   JUMPDEST    
[13d]   DUP3    
[13e]   MSTORE  
[13f]   POP 
[140]   POP 
[141]   JUMP    
[142]   JUMPDEST    
[143]   PUSH1   00
[145]   PUSH1   20
[147]   DUP3    
[148]   ADD 
[149]   SWAP1   
[14a]   POP 
[14b]   PUSH1   95
[14d]   PUSH1   00
[14f]   DUP4    
[150]   ADD 
[151]   DUP5    
[152]   PUSH1   75
[154]   JUMP    
[155]   JUMPDEST    
[156]   SWAP3   
[157]   SWAP2   
[158]   POP 
[159]   POP 
[15a]   JUMP    
[15b]   STOP    
[15c]   STOP    
[15d]   STOP    
[15e]   STOP    
[15f]   STOP    
[160]   STOP    
[161]   STOP    
[162]   STOP    
[163]   STOP    
[164]   STOP    
[165]   STOP    
[166]   STOP    
[167]   STOP    
[168]   STOP    
[169]   STOP    
[16a]   STOP    
[16b]   STOP    
[16c]   STOP    
[16d]   STOP    
[16e]   STOP    
[16f]   STOP    
[170]   STOP    
[171]   STOP    
[172]   STOP    
[173]   STOP    
[174]   STOP    
[175]   STOP    
[176]   STOP    
[177]   STOP    
[178]   STOP    
[179]   STOP    
[17a]   INVALID
```
*/
