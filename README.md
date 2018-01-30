# sl3p
Simple Layer 3 Protocol

Sl3p is a protocol meant to be used on top of Ethernet which aims to ensure the following properties:
 - detection of doubled packets
 - payload length check

While it can be used on any other protocol its main purpose is to be used on raw ethernet.
Therefore it has some constraints for the payload which is at minimum 34 byte to achieve the minimal 60 + 4 byte for ethernet frames.
If used on ethernet it has a maximum size of 1488 byte which is the ethernet payload minus the sl3p header.

## Protocol description

| Sequence number | Length | Payload        |
|-----------------|--------|----------------|
| 64 bit          | 32 bit | 34 - 1488 byte |

| Field           | Length         | Description                                                                                                |
|-----------------|----------------|------------------------------------------------------------------------------------------------------------|
| Sequence number | 8 byte         |indicates packet order; strictly monotonously rising; starts with 1                                    |
| Length          | 4 byte         |indicates raw payload length in bytes; can be 0; cannot be greater than 1488                           |
| Payload         | 34 - 1488 byte |must have the length specified in Length; if Length is less that 34 it must be padded with 0 to 34 byte |

All packets that do not have the described properties must be dropped by the receiver.
If the sequence number is lower than the one of the last packet the packet should be handled as invalid.
When sending the sequence number must be incremented by 1 which allows the receiver to detect packet loss.

## Notes

This protocol is designed to be used on software channels.
Packet loss and reordering due to physical channels are not a design assumption even though both could be detected.
Also it does not contain any direction information.
This should be done by the underlying protocol which is especially important as the sequence numbers are only direction unique.

The main reason this protocol exists is a [Bug in VirtualBox](https://www.virtualbox.org/ticket/3768) that generates duplicated ethernet packets and still occurs in current versions.
This happens especially with broadcast ethernet packets such as ARP or ICMP but also custom ethernet based protocols.
