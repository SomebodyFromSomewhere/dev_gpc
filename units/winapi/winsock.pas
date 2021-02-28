{
    $Id: winsock.pp,v 1.1.2.4 2002/12/28 23:49:20 Chief Exp $
    This file is part of the Free Pascal run time library.
    This unit contains the declarations for the Win32 Socket Library

    Copyright (c) 1999-2000 by Florian Klaempfl,
    member of the Free Pascal development team.

    See the file COPYING.FPC, included in this distribution,
    for details about the copyright.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

    April 2003: Ported to GNU Pascal by Prof. Abimbola A Olowofoyeku
                (The African Chief) - this port has not been completely
                tested - use at your own risk !!!!

}

UNIT winsock;

{$ifdef __GPC__}
 {$i win32.inc}
 {$W-}
{$endif}

INTERFACE

USES
windows;

CONST
       {
         Default maximium number of sockets.
         this does not
         mean that the underlying Windows Sockets implementation has to
         support that many!
       }
       FD_SETSIZE = 64;

TYPE
       u_char = char;
       u_short = word;
       u_int = UINT;
       u_long = dword;
       pu_long = ^u_long;
       TSocket = u_long;
       ptOS_INT = ^tOS_INT;
       tOS_INT = Integer;
       pCharPtr = ^pChar;

       { there is already a procedure called FD_SET, so this
         record was renamed (FK) }
       fdset = RECORD
          fd_count : u_int;
          fd_array : ARRAY [0.. ( FD_SETSIZE ) - 1] OF TSocket;
       END;

       TFDSet = fdset;
       PFDSet = ^fdset;

       timeval = RECORD
          tv_sec : longint;
          tv_usec : longint;
       END;

       TTimeVal = timeval;
       PTimeVal = ^TTimeVal;

       { found no reference to this type in c header files and here. AlexS }
       { minutes west of Greenwich  }
       { type of dst correction  }
       timezone = RECORD
          tz_minuteswest : longint;
          tz_dsttime : longint;
       END;
       TTimeZone = timezone;
       PTimeZone = ^TTimeZone;

    CONST
       IOCPARM_MASK = $7f;
       IOC_VOID = $20000000;
       IOC_OUT = $40000000;
       IOC_IN = $80000000;
       IOC_INOUT = IOC_IN OR IOC_OUT;
       FIONREAD = IOC_OUT OR
         ( ( 4 AND IOCPARM_MASK ) SHL 16 ) OR
         ( 102 SHL 8 ) OR 127;
       FIONBIO = IOC_IN OR
         ( ( 4 AND IOCPARM_MASK ) SHL 16 ) OR
         ( 102 SHL 8 ) OR 126;
       FIOASYNC     = IOC_IN OR
         ( ( 4 AND IOCPARM_MASK ) SHL 16 ) OR
         ( 102 SHL 8 ) OR 125;
       {
         Structures returned by network data base library, taken from the
         BSD file netdb.h.  All addresses are supplied in host order, and
         returned in network order (suitable for use in system calls).
         Slight modifications for differences between Linux and winsock.h
      }
    TYPE
       hostent = RECORD
          { official name of host  }
          h_name : pchar;
          { alias list  }
          h_aliases : pCharPtr;
          { host address type  }
          h_addrtype : SmallInt;
          { length of address  }
          h_length : SmallInt;
          { list of addresses  }
          CASE byte OF
             0 : ( h_addr_list : pCharPtr );
             1 : ( h_addr : pCharPtr )
       END;
       THostEnt = hostent;
       PHostEnt = ^THostEnt;

       {
         Assumption here is that a network number
         fits in an unsigned long -- someday that won't be true!
       }
       netent = RECORD
          { official name of net  }
          n_name : pchar;
          { alias list  }
          n_aliases : pCharPtr;
          { net address type  }
          n_addrtype : SmallInt;
          n_pad1 : SmallInt;    { ensure right packaging }
          { network #  }
          n_net : u_long;
       END;
       TNetEnt = netent;
       PNetEnt = ^TNetEnt;

       servent = RECORD
          { official service name  }
          s_name : pchar;
          { alias list  }
          s_aliases : pCharPtr;
          { port #  }
          s_port : SmallInt;
          n_pad1 : SmallInt;    { ensure right packaging }
          { protocol to use  }
          s_proto : pchar;
       END;
       TServEnt = servent;
       PServEnt = ^TServEnt;

       protoent = RECORD
          { official protocol name  }
          p_name : pchar;
          { alias list  }
          p_aliases : pCharPtr;
          { protocol #  }
          p_proto : SmallInt;
          p_pad1 : SmallInt;    { ensure packaging }
       END;
       TProtoEnt = protoent;
       PProtoEnt = ^TProtoEnt;

    CONST
       {
         Standard well-known IP protocols.
         For some reason there are differences between Linx and winsock.h
       }
       IPPROTO_IP = 0;
       IPPROTO_ICMP = 1;
       IPPROTO_IGMP = 2;
       IPPROTO_GGP = 3;
       IPPROTO_TCP = 6;
       IPPORT_ECHO = 7;
       IPPORT_DISCARD = 9;
       IPPORT_SYSTAT = 11;
       IPPROTO_PUP = 12;
       IPPORT_DAYTIME = 13;
       IPPORT_NETSTAT = 15;
       IPPROTO_UDP = 17;
       IPPROTO_IDP = 22;
       IPPROTO_ND = 77;
       IPPROTO_RAW = 255;
       IPPROTO_MAX = 256;
       IPPORT_FTP = 21;
       IPPORT_TELNET = 23;
       IPPORT_SMTP = 25;
       IPPORT_TIMESERVER = 37;
       IPPORT_NAMESERVER = 42;
       IPPORT_WHOIS = 43;
       IPPORT_MTP = 57;
       IPPORT_TFTP = 69;
       IPPORT_RJE = 77;
       IPPORT_FINGER = 79;
       IPPORT_TTYLINK = 87;
       IPPORT_SUPDUP = 95;
       IPPORT_EXECSERVER = 512;
       IPPORT_LOGINSERVER = 513;
       IPPORT_CMDSERVER = 514;
       IPPORT_EFSSERVER = 520;
       IPPORT_BIFFUDP = 512;
       IPPORT_WHOSERVER = 513;
       IPPORT_ROUTESERVER = 520;
       IPPORT_RESERVED = 1024;

    CONST
       IMPLINK_IP = 155;
       IMPLINK_LOWEXPER = 156;
       IMPLINK_HIGHEXPER = 158;

    TYPE
       SunB = PACKED RECORD
          s_b1, s_b2, s_b3, s_b4 : u_char;
       END;

       SunW = PACKED RECORD
         s_w1, s_w2 : u_short;
       END;

       in_addr = PACKED {@@@}RECORD
          CASE integer OF
             0 : ( S_un_b : SunB );
             1 : ( S_un_w : SunW );
             2 : ( S_addr : u_long );
       END;
       TInAddr = in_addr;
       PInAddr = ^TInAddr;

       sockaddr_in = PACKED RECORD
          sin_family : SmallInt;                        (* 2 byte *)
          CASE integer OF
             0 : ( (* equals to sockaddr_in, size is 16 byte *)
                  sin_port : u_short;                   (* 2 byte *)
                  sin_addr : TInAddr;                   (* 4 byte *)
                  sin_zero : ARRAY [0..8 - 1] OF char;     (* 8 byte *)
                 );
             1 : ( (* equals to sockaddr, size is 16 byte *)
                  sin_data : ARRAY [0..14 - 1] OF char;    (* 14 byte *)
                 );
         END;
       TSockAddrIn = sockaddr_in;
       PSockAddrIn = ^TSockAddrIn;
       TSockAddr = sockaddr_in;
       PSockAddr = ^TSockAddr;

    CONST
       INADDR_ANY = $00000000;
       INADDR_LOOPBACK = $7F000001;
       INADDR_BROADCAST = $FFFFFFFF;

       IN_CLASSA_NET = $ff000000;
       IN_CLASSA_NSHIFT = 24;
       IN_CLASSA_HOST = $00ffffff;
       IN_CLASSA_MAX = 128;
       IN_CLASSB_NET = $ffff0000;
       IN_CLASSB_NSHIFT = 16;
       IN_CLASSB_HOST = $0000ffff;
       IN_CLASSB_MAX = 65536;
       IN_CLASSC_NET = $ffffff00;
       IN_CLASSC_NSHIFT = 8;
       IN_CLASSC_HOST = $000000ff;
       INADDR_NONE = $ffffffff;

       WSADESCRIPTION_LEN = 256;
       WSASYS_STATUS_LEN = 128;

    TYPE
       WSADATA = RECORD
          wVersion : WORD;              { 2 byte, ofs 0 }
          wHighVersion : WORD;          { 2 byte, ofs 2 }
          szDescription : ARRAY [0.. ( WSADESCRIPTION_LEN + 1 ) - 1] OF char; { 257 byte, ofs 4 }
          szSystemStatus : ARRAY [0.. ( WSASYS_STATUS_LEN + 1 ) - 1] OF char; { 129 byte, ofs 261 }
          iMaxSockets : word;           { 2 byte, ofs 390 }
          iMaxUdpDg : word;             { 2 byte, ofs 392 }
          pad1 : SmallInt;              { 2 byte, ofs 394 } { ensure right packaging }
          lpVendorInfo : pchar;         { 4 byte, ofs 396 }
       END;                             { total size 400 }
       TWSAData = WSADATA;
       PWSAData = TWSAData;

    CONST
       IP_OPTIONS = 1;
       IP_MULTICAST_IF = 2;
       IP_MULTICAST_TTL = 3;
       IP_MULTICAST_LOOP = 4;
       IP_ADD_MEMBERSHIP = 5;
       IP_DROP_MEMBERSHIP = 6;
       IP_DEFAULT_MULTICAST_TTL = 1;
       IP_DEFAULT_MULTICAST_LOOP = 1;
       IP_MAX_MEMBERSHIPS = 20;

    TYPE
       ip_mreq = RECORD
            imr_multiaddr : in_addr;
            imr_interface : in_addr;
         END;

    {
       Definitions related to sockets: types, address families, options,
       taken from the BSD file sys/socket.h.
    }
    CONST
       INVALID_SOCKET = NOT ( 1 );
       SOCKET_ERROR = - 1;
       SOCK_STREAM = 1;
       SOCK_DGRAM = 2;
       SOCK_RAW = 3;
       SOCK_RDM = 4;
       SOCK_SEQPACKET = 5;

      { For setsockoptions(2)  }
       SO_DEBUG = $0001;
       SO_ACCEPTCONN = $0002;
       SO_REUSEADDR = $0004;
       SO_KEEPALIVE = $0008;
       SO_DONTROUTE = $0010;
       SO_BROADCAST = $0020;
       SO_USELOOPBACK = $0040;
       SO_LINGER = $0080;
       SO_OOBINLINE = $0100;
       {
         Additional options.
       }
       { send buffer size  }
       SO_SNDBUF = $1001;
       { receive buffer size  }
       SO_RCVBUF = $1002;
       { send low-water mark  }
       SO_SNDLOWAT = $1003;
       { receive low-water mark  }
       SO_RCVLOWAT = $1004;
       { send timeout  }
       SO_SNDTIMEO = $1005;
       { receive timeout  }
       SO_RCVTIMEO = $1006;
       { get error status and clear  }
       SO_ERROR = $1007;
       { get socket type  }
       SO_TYPE = $1008;

       {
         Options for connect and disconnect data and options.  Used only by
         non-TCP/IP transports such as DECNet, OSI TP4, etc.
       }
       SO_CONNDATA = $7000;
       SO_CONNOPT = $7001;
       SO_DISCDATA = $7002;
       SO_DISCOPT = $7003;
       SO_CONNDATALEN = $7004;
       SO_CONNOPTLEN = $7005;
       SO_DISCDATALEN = $7006;
       SO_DISCOPTLEN = $7007;

       {
         Option for opening sockets for synchronous access.
       }
       SO_OPENTYPE = $7008;
       SO_SYNCHRONOUS_ALERT = $10;
       SO_SYNCHRONOUS_NONALERT = $20;

       {
         Other NT-specific options.
       }
       SO_MAXDG = $7009;
       SO_MAXPATHDG = $700A;
       SO_UPDATE_ACCEPT_CONTEXT = $700B;
       SO_CONNECT_TIME = $700C;

       {
         TCP options.
       }
       TCP_NODELAY = $0001;
       TCP_BSDURGENT = $7000;

       {
         Address families.
       }
       { unspecified  }
       AF_UNSPEC = 0;
       { local to host (pipes, portals)  }
       AF_UNIX = 1;
       { internetwork: UDP, TCP, etc.  }
       AF_INET = 2;
       { arpanet imp addresses  }
       AF_IMPLINK = 3;
       { pup protocols: e.g. BSP  }
       AF_PUP = 4;
       { mit CHAOS protocols  }
       AF_CHAOS = 5;
       { IPX and SPX  }
       AF_IPX = 6;
       { XEROX NS protocols  }
       AF_NS = 6;
       { ISO protocols  }
       AF_ISO = 7;
       { OSI is ISO  }
       AF_OSI = AF_ISO;
       { european computer manufacturers  }
       AF_ECMA = 8;
       { datakit protocols  }
       AF_DATAKIT = 9;
       { CCITT protocols, X.25 etc  }
       AF_CCITT = 10;
       { IBM SNA  }
       AF_SNA = 11;
       { DECnet  }
       AF_DECnet = 12;
       { Direct data link interface  }
       AF_DLI = 13;
       { LAT  }
       AF_LAT = 14;
       { NSC Hyperchannel  }
       AF_HYLINK = 15;
       { AppleTalk  }
       AF_APPLETALK = 16;
       { NetBios-style addresses  }
       AF_NETBIOS = 17;
       { VoiceView }
       AF_VOICEVIEW = 18;
       { FireFox }
       AF_FIREFOX = 19;
       { Somebody is using this! }
       AF_UNKNOWN1 = 20;
       { Banyan }
       AF_BAN = 21;

       AF_MAX = 22;

    TYPE
       {
         Structure used by kernel to pass protocol
         information in raw sockets.
       }
       sockproto = PACKED {@@@}RECORD
          sp_family : u_short;
          sp_protocol : u_short;
       END;
       TSockProto = sockproto;
       PSockProto = ^TSockProto;

    CONST
       {
         Protocol families, same as address families for now.
       }
       PF_UNSPEC = AF_UNSPEC;
       PF_UNIX = AF_UNIX;
       PF_INET = AF_INET;
       PF_IMPLINK = AF_IMPLINK;
       PF_PUP = AF_PUP;
       PF_CHAOS = AF_CHAOS;
       PF_NS = AF_NS;
       PF_IPX = AF_IPX;
       PF_ISO = AF_ISO;
       PF_OSI = AF_OSI;
       PF_ECMA = AF_ECMA;
       PF_DATAKIT = AF_DATAKIT;
       PF_CCITT = AF_CCITT;
       PF_SNA = AF_SNA;
       PF_DECnet = AF_DECnet;
       PF_DLI = AF_DLI;
       PF_LAT = AF_LAT;
       PF_HYLINK = AF_HYLINK;
       PF_APPLETALK = AF_APPLETALK;
       PF_VOICEVIEW = AF_VOICEVIEW;
       PF_FIREFOX = AF_FIREFOX;
       PF_UNKNOWN1 = AF_UNKNOWN1;
       PF_BAN = AF_BAN;
       PF_MAX = AF_MAX;

    TYPE
       {
         Structure used for manipulating linger option.
       }
       linger = PACKED {@@@}RECORD
          l_onoff : u_short;
          l_linger : u_short;
       END;
       TLinger = linger;
       PLinger = ^TLinger;

    CONST
       {
         Level number for (get/set)sockopt() to apply to socket itself.
       }
       { options for socket level  }
       SOL_SOCKET = $ffff;
       {
         Maximum queue length specifiable by listen.
       }
       SOMAXCONN = 5;
       { process out-of-band data  }
       MSG_OOB = $1;
       { peek at incoming message  }
       MSG_PEEK = $2;
       { send without using routing tables  }
       MSG_DONTROUTE = $4;
       MSG_MAXIOVLEN = 16;
       { partial send or recv for message xport  }
       MSG_PARTIAL = $8000;

       {
         Define constant based on rfc883, used by gethostbyxxxx() calls.
       }
       MAXGETHOSTSTRUCT = 1024;
       MAXHOSTNAMELEN = MAXGETHOSTSTRUCT;

       {
         Define flags to be used with the WSAAsyncSelect() call.
       }
       FD_READ = $01;
       FD_WRITE = $02;
       FD_OOB = $04;
       FD_ACCEPT = $08;
       FD_CONNECT = $10;
       FD_CLOSE = $20;

       {
         All Windows Sockets error constants are biased by WSABASEERR from
         the "normal"
       }
       WSABASEERR = 10000;

       {
         Windows Sockets definitions of regular Microsoft C error constants
       }
       WSAEINTR = WSABASEERR + 4;
       WSAEBADF = WSABASEERR + 9;
       WSAEACCES = WSABASEERR + 13;
       WSAEFAULT = WSABASEERR + 14;
       WSAEINVAL = WSABASEERR + 22;
       WSAEMFILE = WSABASEERR + 24;

       {
         Windows Sockets definitions of regular Berkeley error constants
       }
       WSAEWOULDBLOCK = WSABASEERR + 35;
       WSAEINPROGRESS = WSABASEERR + 36;
       WSAEALREADY = WSABASEERR + 37;
       WSAENOTSOCK = WSABASEERR + 38;
       WSAEDESTADDRREQ = WSABASEERR + 39;
       WSAEMSGSIZE = WSABASEERR + 40;
       WSAEPROTOTYPE = WSABASEERR + 41;
       WSAENOPROTOOPT = WSABASEERR + 42;
       WSAEPROTONOSUPPORT = WSABASEERR + 43;
       WSAESOCKTNOSUPPORT = WSABASEERR + 44;
       WSAEOPNOTSUPP = WSABASEERR + 45;
       WSAEPFNOSUPPORT = WSABASEERR + 46;
       WSAEAFNOSUPPORT = WSABASEERR + 47;
       WSAEADDRINUSE = WSABASEERR + 48;
       WSAEADDRNOTAVAIL = WSABASEERR + 49;
       WSAENETDOWN = WSABASEERR + 50;
       WSAENETUNREACH = WSABASEERR + 51;
       WSAENETRESET = WSABASEERR + 52;
       WSAECONNABORTED = WSABASEERR + 53;
       WSAECONNRESET = WSABASEERR + 54;
       WSAENOBUFS = WSABASEERR + 55;
       WSAEISCONN = WSABASEERR + 56;
       WSAENOTCONN = WSABASEERR + 57;
       WSAESHUTDOWN = WSABASEERR + 58;
       WSAETOOMANYREFS = WSABASEERR + 59;
       WSAETIMEDOUT = WSABASEERR + 60;
       WSAECONNREFUSED = WSABASEERR + 61;
       WSAELOOP = WSABASEERR + 62;
       WSAENAMETOOLONG = WSABASEERR + 63;
       WSAEHOSTDOWN = WSABASEERR + 64;
       WSAEHOSTUNREACH = WSABASEERR + 65;
       WSAENOTEMPTY = WSABASEERR + 66;
       WSAEPROCLIM = WSABASEERR + 67;
       WSAEUSERS = WSABASEERR + 68;
       WSAEDQUOT = WSABASEERR + 69;
       WSAESTALE = WSABASEERR + 70;
       WSAEREMOTE = WSABASEERR + 71;
       WSAEDISCON = WSABASEERR + 101;

       {
         Extended Windows Sockets error constant definitions
       }
       WSASYSNOTREADY = WSABASEERR + 91;
       WSAVERNOTSUPPORTED = WSABASEERR + 92;
       WSANOTINITIALISED = WSABASEERR + 93;
       {
         Error return codes from gethostbyname() and gethostbyaddr()
         (when using the resolver). Note that these errors are
         retrieved via WSAGetLastError() and must therefore follow
         the rules for avoiding clashes with error numbers from
         specific implementations or language run-time systems.
         For this reason the codes are based at WSABASEERR+1001.
         Note also that [WSA]NO_ADDRESS is defined only for
         compatibility purposes.
        }
       WSAHOST_NOT_FOUND = WSABASEERR + 1001;
       HOST_NOT_FOUND = WSAHOST_NOT_FOUND;
       { Non-Authoritative: Host not found, or SERVERFAIL  }
       WSATRY_AGAIN = WSABASEERR + 1002;
       TRY_AGAIN = WSATRY_AGAIN;

       { Non recoverable errors, FORMERR, REFUSED, NOTIMP  }
       WSANO_RECOVERY = WSABASEERR + 1003;
       NO_RECOVERY = WSANO_RECOVERY;

       { Valid name, no data record of requested type  }
       WSANO_DATA = WSABASEERR + 1004;
       NO_DATA = WSANO_DATA;

       { no address, look for MX record  }
       WSANO_ADDRESS = WSANO_DATA;
       NO_ADDRESS = WSANO_ADDRESS;

    CONST
       {
         Windows Sockets errors redefined as regular Berkeley error constants.
       }
       EWOULDBLOCK = WSAEWOULDBLOCK;
       EINPROGRESS = WSAEINPROGRESS;
       EALREADY = WSAEALREADY;
       ENOTSOCK = WSAENOTSOCK;
       EDESTADDRREQ = WSAEDESTADDRREQ;
       EMSGSIZE = WSAEMSGSIZE;
       EPROTOTYPE = WSAEPROTOTYPE;
       ENOPROTOOPT = WSAENOPROTOOPT;
       EPROTONOSUPPORT = WSAEPROTONOSUPPORT;
       ESOCKTNOSUPPORT = WSAESOCKTNOSUPPORT;
       EOPNOTSUPP = WSAEOPNOTSUPP;
       EPFNOSUPPORT = WSAEPFNOSUPPORT;
       EAFNOSUPPORT = WSAEAFNOSUPPORT;
       EADDRINUSE = WSAEADDRINUSE;
       EADDRNOTAVAIL = WSAEADDRNOTAVAIL;
       ENETDOWN = WSAENETDOWN;
       ENETUNREACH = WSAENETUNREACH;
       ENETRESET = WSAENETRESET;
       ECONNABORTED = WSAECONNABORTED;
       ECONNRESET = WSAECONNRESET;
       ENOBUFS = WSAENOBUFS;
       EISCONN = WSAEISCONN;
       ENOTCONN = WSAENOTCONN;
       ESHUTDOWN = WSAESHUTDOWN;
       ETOOMANYREFS = WSAETOOMANYREFS;
       ETIMEDOUT = WSAETIMEDOUT;
       ECONNREFUSED = WSAECONNREFUSED;
       ELOOP = WSAELOOP;
       ENAMETOOLONG = WSAENAMETOOLONG;
       EHOSTDOWN = WSAEHOSTDOWN;
       EHOSTUNREACH = WSAEHOSTUNREACH;
       ENOTEMPTY = WSAENOTEMPTY;
       EPROCLIM = WSAEPROCLIM;
       EUSERS = WSAEUSERS;
       EDQUOT = WSAEDQUOT;
       ESTALE = WSAESTALE;
       EREMOTE = WSAEREMOTE;

       TF_DISCONNECT = $01;
       TF_REUSE_SOCKET = $02;
       TF_WRITE_BEHIND = $04;

       {
         Options for use with [gs]etsockopt at the IP level.
       }
       IP_TTL = 7;
       IP_TOS = 8;
       IP_DONTFRAGMENT = 9;

    TYPE
      { _TRANSMIT_FILE_BUFFERS = record
          Head : Pointer;
          HeadLength : dword;
          Tail : Pointer;
          TailLength : dword;
       end;
       TRANSMIT_FILE_BUFFERS = _TRANSMIT_FILE_BUFFERS;
       }
       TTransmitFileBuffers = _TRANSMIT_FILE_BUFFERS;
       PTransmitFileBuffers = ^TTransmitFileBuffers;
    { Socket function prototypes  }
    FUNCTION accept ( s : TSocket; addr : PSockAddr; addrlen : ptOS_INT ) : TSocket; WINAPI ( 'accept' );
    FUNCTION bind ( s : TSocket; CONST  addr : TSockaddr; namelen : tOS_INT ) : tOS_INT; WINAPI ( 'bind' );
    FUNCTION closesocket ( s : TSocket ) : tOS_INT; WINAPI ( 'closesocket' );
    FUNCTION connect ( s : TSocket; CONST aname : TSockAddr; namelen : tOS_INT ) : tOS_INT; WINAPI ( 'connect' );
    FUNCTION ioctlsocket ( s : TSocket; cmd : longint; VAR arg : u_long ) : tOS_INT; WINAPI ( 'ioctlsocket' ); { really a c-long }
    FUNCTION getpeername ( s : TSocket; VAR aname : TSockAddr;VAR namelen : tOS_INT ) : tOS_INT;
      WINAPI ( 'getpeername' );
    FUNCTION getsockname ( s : TSocket; VAR aname : TSockAddr;VAR namelen : tOS_INT ) : tOS_INT;
      WINAPI ( 'getsockname' );
    FUNCTION getsockopt ( s : TSocket; level : tOS_INT; optname : tOS_INT; optval : pchar;VAR optlen : tOS_INT ) : tOS_INT;
      WINAPI ( 'getsockopt' );
    FUNCTION htonl ( hostlong : u_long ) : u_long; WINAPI ( 'htonl' );
    FUNCTION htons ( hostshort : u_short ) : u_short;WINAPI ( 'htons' );
    FUNCTION inet_addr ( cp : pchar ) : cardinal; WINAPI ( 'inet_addr' );
    FUNCTION inet_ntoa ( i : TInAddr ) : pchar; WINAPI ( 'inet_ntoa' );
    FUNCTION listen ( s : TSocket; backlog : tOS_INT ) : tOS_INT; WINAPI ( 'listen' );
    FUNCTION ntohl ( netlong : u_long ) : u_long; WINAPI ( 'ntohl' );
    FUNCTION ntohs ( netshort : u_short ) : u_short; WINAPI ( 'ntohs' );
    FUNCTION recv ( s : TSocket;{VAR @@}buf : pChar; len : tOS_INT; flags : tOS_INT ) : tOS_INT; WINAPI ( 'recv' );
    FUNCTION recvfrom ( s : TSocket;{VAR @@}buf : pChar; len : tOS_INT; flags : tOS_INT;CONST from : TSockAddr; VAR fromlen : tOS_INT ) : tOS_INT;
      WINAPI ( 'recvfrom' );
    FUNCTION select ( nfds : tOS_INT; readfds, writefds, exceptfds : PFDSet;timeout : PTimeVal ) : tOS_INT;
      WINAPI ( 'select' );
    FUNCTION send ( s : TSocket;{Const @@}buf : pChar; len : tOS_INT; flags : tOS_INT ) : tOS_INT;
      WINAPI ( 'send' );
    FUNCTION sendto ( s : TSocket; buf : pchar; len : tOS_INT; flags : tOS_INT;CONST toaddr : TSockAddr; tolen : tOS_INT ) : tOS_INT;
      WINAPI ( 'sendto' );
    FUNCTION setsockopt ( s : TSocket; level : tOS_INT; optname : tOS_INT; optval : pchar; optlen : tOS_INT ) : tOS_INT;
      WINAPI ( 'setsockopt' );
    FUNCTION shutdown ( s : TSocket; how : tOS_INT ) : tOS_INT;
      WINAPI ( 'shutdown' );
    FUNCTION socket ( af : tOS_INT; t : tOS_INT; protocol : tOS_INT ) : TSocket;
      WINAPI ( 'socket' );

    { Database function prototypes  }
    FUNCTION gethostbyaddr ( addr : pchar; len : tOS_INT; t : tOS_INT ) : PHostEnt; WINAPI ( 'gethostbyaddr' );
    FUNCTION gethostbyname ( name : pchar ) : PHostEnt; WINAPI ( 'gethostbyname' );
    FUNCTION gethostname ( name : pchar; namelen : tOS_INT ) : tOS_INT; WINAPI ( 'gethostname' );
    FUNCTION getservbyport ( port : tOS_INT; proto : pchar ) : PServEnt; WINAPI ( 'getservbyport' );
    FUNCTION getservbyname ( name : pchar; proto : pchar ) : PServEnt; WINAPI ( 'getservbyname' );
    FUNCTION getprotobynumber ( proto : tOS_INT ) : PProtoEnt; WINAPI ( 'getprotobynumber' );
    FUNCTION getprotobyname ( name : pchar ) : PProtoEnt; WINAPI ( 'getprotobyname' );

    { Microsoft Windows Extension function prototypes  }
    FUNCTION WSAStartup ( wVersionRequired : word;VAR WSAData : TWSADATA ) : tOS_INT;
      WINAPI ( 'WSAStartup' );
    FUNCTION WSACleanup : tOS_INT; WINAPI ( 'WSACleanup' );
    PROCEDURE WSASetLastError ( iError : tOS_INT ); WINAPI ( 'WSASetLastError' );
    FUNCTION WSAGetLastError : tOS_INT; WINAPI ( 'WSAGetLastError' );
    FUNCTION WSAIsBlocking : BOOL; WINAPI ( 'WSAIsBlocking' );
    FUNCTION WSAUnhookBlockingHook : tOS_INT; WINAPI ( 'WSAUnhookBlockingHook' );
    FUNCTION WSASetBlockingHook ( lpBlockFunc : TFarProc ) : TFarProc; WINAPI ( 'WSASetBlockingHook' );
    FUNCTION WSACancelBlockingCall : tOS_INT; WINAPI ( 'WSACancelBlockingCall' );
    FUNCTION WSAAsyncGetServByName ( hWnd : HWND; wMsg : u_int; name : pchar; proto : pchar; buf : pchar;
                                   buflen : tOS_INT ) : THandle; WINAPI ( 'WSAAsyncGetServByName' );
    FUNCTION WSAAsyncGetServByPort ( hWnd : HWND; wMsg : u_int; port : tOS_INT; proto : pchar; buf : pchar;
                                   buflen : tOS_INT ) : THandle; WINAPI ( 'WSAAsyncGetServByPort' );
    FUNCTION WSAAsyncGetProtoByName ( hWnd : HWND; wMsg : u_int; name : pchar; buf : pchar; buflen : tOS_INT ) : THandle;
      WINAPI ( 'WSAAsyncGetProtoByName' );
    FUNCTION WSAAsyncGetProtoByNumber ( hWnd : HWND; wMsg : u_int; number : tOS_INT; buf : pchar; buflen : tOS_INT ) : THandle;
      WINAPI ( 'WSAAsyncGetProtoByNumber' );
    FUNCTION WSAAsyncGetHostByName ( hWnd : HWND; wMsg : u_int; name : pchar; buf : pchar; buflen : tOS_INT ) : THandle;
      WINAPI ( 'WSAAsyncGetHostByName' );
    FUNCTION WSAAsyncGetHostByAddr ( hWnd : HWND; wMsg : u_int; addr : pchar; len : tOS_INT; t : tOS_INT;
                                   buf : pchar; buflen : tOS_INT ) : THandle;
                                   WINAPI ( 'WSAAsyncGetHostByAddr' );
    FUNCTION WSACancelAsyncRequest ( hAsyncTaskHandle : THandle ) : tOS_INT;
      WINAPI ( 'WSACancelAsyncRequest' );
    FUNCTION WSAAsyncSelect ( s : TSocket; hWnd : HWND; wMsg : u_int; lEvent : longint ) : tOS_INT;  { really a c-long }
      WINAPI ( 'WSAAsyncSelect' );
    FUNCTION WSARecvEx ( s : TSocket;{VAR }buf : pChar; len : tOS_INT; flags : ptOS_INT ) : tOS_INT;
      WINAPI ( 'WSARecvEx' );
    FUNCTION __WSAFDIsSet ( s : TSocket; VAR FDSet : TFDSet ) : Bool;
      WINAPI ( '__WSAFDIsSet' );
    FUNCTION __WSAFDIsSet_ ( s : TSocket; VAR FDSet : TFDSet ) : tOS_INT;
      WINAPI ( '__WSAFDIsSet' );
    FUNCTION TransmitFile ( hSocket : TSocket; hFile : THandle; nNumberOfBytesToWrite : dword;
                          nNumberOfBytesPerSend : DWORD; lpOverlapped : POverlapped;
                          lpTransmitBuffers : PTransmitFileBuffers; dwReserved : dword ) : Bool;
                          WINAPI ( 'TransmitFile' );

    FUNCTION AcceptEx ( sListenSocket, sAcceptSocket : TSocket;
                      lpOutputBuffer : Pointer; dwReceiveDataLength, dwLocalAddressLength,
                      dwRemoteAddressLength : dword; VAR lpdwBytesReceived : dword;
                      lpOverlapped : POverlapped ) : Bool;
                      WINAPI ( 'AcceptEx' );

    PROCEDURE GetAcceptExSockaddrs ( lpOutputBuffer : Pointer;
                                   dwReceiveDataLength, dwLocalAddressLength, dwRemoteAddressLength : dword;
                                   VAR LocalSockaddr : TSockAddr; VAR LocalSockaddrLength : tOS_INT;
                                   VAR RemoteSockaddr : TSockAddr; VAR RemoteSockaddrLength : tOS_INT );
                                   WINAPI ( 'GetAcceptExSockaddrs' );

    FUNCTION WSAMakeSyncReply ( Buflen, Error : Word ) : dword;
    FUNCTION WSAMakeSelectReply ( Event, Error : Word ) : dword;
    FUNCTION WSAGetAsyncBuflen ( Param : dword ) : Word;
    FUNCTION WSAGetAsyncError ( Param : dword ) : Word;
    FUNCTION WSAGetSelectEvent ( Param : dword ) : Word;
    FUNCTION WSAGetSelectError ( Param : dword ) : Word;
    PROCEDURE FD_CLR ( Socket : TSocket; VAR FDSet : TFDSet );
    FUNCTION FD_ISSET ( Socket : TSocket; VAR FDSet : TFDSet ) : Boolean;
    PROCEDURE FD_SET ( Socket : TSocket; VAR FDSet : TFDSet );
    PROCEDURE FD_ZERO ( VAR FDSet : TFDSet );

IMPLEMENTATION

FUNCTION Lo ( x : LongestInt ) : Byte;
BEGIN
  Lo := LongestCard ( x ) AND $ff
END;

FUNCTION Hi ( x : LongestInt ) : Byte;
BEGIN
  Hi := ( LongestCard ( x ) div $100 ) AND $ff
END;

    {
      Implementation of the helper routines
    }
    FUNCTION WSAMakeSyncReply ( Buflen, Error : Word ) : dword;

      BEGIN
         WSAMakeSyncReply := MakeLong ( Buflen, Error );
      END;

    FUNCTION WSAMakeSelectReply ( Event, Error : Word ) : dword;

      BEGIN
         WSAMakeSelectReply := MakeLong ( Event, Error );
      END;

    FUNCTION WSAGetAsyncBuflen ( Param : dword ) : Word;

      BEGIN
         WSAGetAsyncBuflen := lo ( Param );
      END;

    FUNCTION WSAGetAsyncError ( Param : dword ) : Word;

      BEGIN
         WSAGetAsyncError := hi ( Param );
      END;

    FUNCTION WSAGetSelectEvent ( Param : dword ) : Word;

      BEGIN
         WSAGetSelectEvent := lo ( Param );
      END;

    FUNCTION WSAGetSelectError ( Param : dword ) : Word;

      BEGIN
         WSAGetSelectError := hi ( Param );
      END;

    PROCEDURE FD_CLR ( Socket : TSocket; VAR FDSet : TFDSet );

      VAR
         i : u_int;

      BEGIN
         i := 0;
         WHILE i < FDSet.fd_count DO
           BEGIN
              IF FDSet.fd_array [i] = Socket THEN
                BEGIN
                   WHILE i < FDSet.fd_count - 1 DO
                     BEGIN
                        FDSet.fd_array [i] := FDSet.fd_array [i + 1];
                        inc ( i );
                     END;
                   dec ( FDSet.fd_count );
                   break;
                END;
              inc ( i );
           END;
      END;

    FUNCTION FD_ISSET ( Socket : TSocket; VAR FDSet : TFDSet ) : Boolean;

      BEGIN
         FD_ISSET := __WSAFDIsSet ( Socket, FDSet );
      END;

    PROCEDURE FD_SET ( Socket : TSocket; VAR FDSet : TFDSet );

      BEGIN
         IF FDSet.fd_count < FD_SETSIZE THEN
           BEGIN
              FDSet.fd_array [FDSet.fd_count] := Socket;
              Inc ( FDSet.fd_count );
           END;
      END;

    PROCEDURE FD_ZERO ( VAR FDSet : TFDSet );

      BEGIN
         FDSet.fd_count := 0;
      END;

BEGIN
 // You need TO link WITH either - lws2_32 ( Winsock 2 ) OR - lwsock32 ( Winsock 1 ) .
 {$l wsock32} // ???
END.
{
  $Log: winsock.pp,v $
  Revision 1.1.2.4  2002/12/28 23:49:20  Chief
    * Ported to GNU Pascal

  Revision 1.1.2.3  2002/01/19 11:48:20  peter
    * more functions added from webbugs

  Revision 1.1.2.2  2001/06/06 22:00:40  peter
    * Win32 fixes

  Revision 1.1.2.1  2001/04/10 20:38:37  peter
    * fixed argument names

  Revision 1.1  2000/07/13 06:31:22  michael
  + Initial import

  Revision 1.11  2000/06/21 22:26:08  pierre
   * link smart and FIXXX const corrected

  Revision 1.10  2000/03/20 16:14:37  alex
   * extended to make use of OS_TYPES unit.

  Revision 1.9  2000/03/01 11:18:39  pierre
   * typo correction from bug 864

  Revision 1.8  2000/02/23 16:48:10  alex
  fixed structure sizes for any slang on 32 bit platform,
  fiexed buggy conversions from c-short to pascal-integer,
  needs some more work to be Win64 compliant,

  szDescription/szSystemStatus is a zero terminated string with extra zero.

  Revision 1.7  2000/02/23 15:00:55  jonas
    * fixed WSADATA record structure bug

  Revision 1.6  2000/02/20 20:34:02  florian
    * dub id fixed

  Revision 1.5  2000/02/09 16:59:35  peter
    * truncated log

  Revision 1.4  2000/01/07 16:41:53  daniel
    * copyright 2000

}
