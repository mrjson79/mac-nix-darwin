{ pkgs, ... }: {
  networking.wg-quick.interfaces = let
    server_ip = "ip";
  in {
    wg0 = {
      # IP address of this machine in the *tunnel network*
      address = [
        "192.168.68.7/32"
      ];


      # Path to the private key file.
      privateKeyFile = "path";

      peers = [{
        publicKey = "key";
        allowedIPs = [ "192.168.68.1/24" ];
        endpoint = "${server_ip}:51820";
        persistentKeepalive = 25;
      }];
    };
  };
}