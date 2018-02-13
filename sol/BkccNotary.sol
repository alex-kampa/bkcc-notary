pragma solidity ^0.4.19;

// ----------------------------------------------------------------------------
//
// BKCC Notary contract
//
// ----------------------------------------------------------------------------


// ----------------------------------------------------------------------------
//
// Owned contract
//
// ----------------------------------------------------------------------------

contract Owned {

  address public owner;
  address public newOwner;

  // Events ---------------------------

  event OwnershipTransferProposed(address indexed _from, address indexed _to);
  event OwnershipTransferred(address indexed _to);

  // Modifier -------------------------

  modifier onlyOwner {
    require( msg.sender == owner );
    _;
  }

  // Functions ------------------------

  function Owned() public {
    owner = msg.sender;
  }

  function transferOwnership(address _newOwner) public onlyOwner {
    require( _newOwner != owner );
    require( _newOwner != address(0x0) );
    newOwner = _newOwner;
    OwnershipTransferProposed(owner, _newOwner);
  }

  function acceptOwnership() public {
    require( msg.sender == newOwner );
    owner = newOwner;
    OwnershipTransferred(owner);
  }

}


// ----------------------------------------------------------------------------
//
// BKCC Notary
//
// ----------------------------------------------------------------------------

contract BkccNotary is Owned {

  mapping(address => bool) public whitelist;
  mapping(uint8 => bool) public types;
  
  // Events ---------------------------
  
  event TypeAdded(uint8 _type);
  event WhitelistUpdated(address _user, bool _isWhitelisted);
  event HashRegistered(address _user, string _hash, uint8 _type);

  // Basic Functions ------------------

  /* Initialize */

  function BkccNotary() public {}
  
  /* Add a type */

  function addType(uint8 _type) onlyOwner public {
	types[_type] = true;
	TypeAdded(_type);
  }
  
  /* Manage whitelist */

  function addToWhitelist(address _user) onlyOwner public {
    whitelist[_user] = true;
    WhitelistUpdated(_user, true);
  }

  function removeFromWhitelist(address _user) onlyOwner public {
    whitelist[_user] = false;
    WhitelistUpdated(_user, false);
  }

  /* Registration */
  
  function register(string _hash, uint8 _type) public {
    require( whitelist[msg.sender] );
	require( types[_type] );
	HashRegistered(msg.sender, _hash, _type);
  }

}