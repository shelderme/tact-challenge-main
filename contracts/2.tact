import "@stdlib/deploy";

/*
  TASK 2 - Proxy 
  Create a contract that forwards all received TONs
  to the admin contract (whose address is set in init_store).
  Message from this proxy contract to the admin contract should contain:
    - Address of user who sent original message (should be stored in the outcoming body's data/bits)
    - Original message that proxy smart contract received from user (should be stored in the outcoming body's first ref)
  Also, if admin contract decides to reject message (if it sends to the proxy "Refund" message with opcode=0x44),
  proxy contract needs to forward all TONs (attached to Refund message) back to the user.
  User address will be provided in Refund message body as "sender".
  In refund transaction, it is important to have a check that the refund message came from the admin address
*/

message(0x44) Refund {
  queryId: Int as uint64;
  tonAmount: Int as uint32;
  sender: Address;
}


contract TaskeTwo with Deployable {
  admin: Address;
  
  init(admin: Address) {
    self.admin = admin;
  }
  fun OnlyOwner() {
    require(sender() == self.admin, "only owner is allowed");
    }
  receive(){
    //accept incoming TON transeferes
    

    if (myBalance() > 0.01) {
        send(SendParameters {
            to: self.admin,
            value: 0,
            bounce: true,
            mode: SendRemainingBalance + SendIgnoreErrors

        });
    }
  }
  
  receive(msg: Refund) {
    self.OnlyOwner();
    send(SendParameters {
            to: msg.sender,
            value: msg.tonAmount,
            bounce: true,
            mode: SendIgnoreErrors
        });

  }

  receive(msg: Slice) {
  }

  get fun balance(): Int {
    return myBalance();
  }
}
