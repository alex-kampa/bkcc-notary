# bkcc-notary

Super simple Solidity code for notarisation on the blockchain

Restrictions:

1) types are identified only by numbers, the contract does not know what they are

2) as a result of 1, there is no format check on hash function results

3) registration of hash strings can be seen only in the event log (via HashRegistered)
