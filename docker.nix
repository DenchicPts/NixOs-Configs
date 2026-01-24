{ config, pkgs, ... }:

{
  virtualisation.docker.enable = true;
  






  systemd.services.n8n-daily = {
    description = "N8N Daily News Service";
    after = [ "docker.service" ];
    requires = [ "docker.service" ];
    
    path = with pkgs; [ docker iputils ];
    
    serviceConfig = {
      Type = "oneshot";
      User = "denchicpts";
      WorkingDirectory = "/home/denchicpts/Documents/docker_compose/n8n";
    };
      
    script = ''
      echo "Waiting for internet..."
      
      until ping -c1 -W1 8.8.8.8 >/dev/null 2>&1; do
        sleep 10
      done
      
      echo "Internet is up, starting n8n"
      docker compose up -d
      
      sleep 600
      
      echo "Stopping n8n"
      docker compose down
    '';
  };

  systemd.timers.n8n-daily = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "08:00";
      Persistent = true;
      RandomizedDelaySec = "2min";
    };
  };
}