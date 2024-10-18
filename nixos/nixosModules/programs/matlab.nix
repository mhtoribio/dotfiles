{ config, pkgs, options, lib, outputs, ... }: {
  environment.systemPackages = with pkgs; [ matlab ];
}
