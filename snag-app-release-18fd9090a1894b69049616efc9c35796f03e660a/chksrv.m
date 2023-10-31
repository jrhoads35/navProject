function available = chksrv(noisy)
    if ~exist('noisy','var')
        noisy = true;
    end
    udout = webread("https://updown.io/api/checks?api-key=ro-pQns5GKF9Wdcbhkqd376");
    nextcheck = datetime(udout.next_check_at,'InputFormat','yyyy-MM-dd''T''HH:mm:ss''Z''',TimeZone='Z');
    if udout.down
        downsince = datetime(udout.down_since,'InputFormat','yyyy-MM-dd''T''HH:mm:ss''Z''',TimeZone='Z');
        if noisy
            disp(sprintf("ORaaS has been down for %s, status is %s", nowutc(true)-downsince, udout.error))
            disp(sprintf("Next check in %s", nextcheck-nowutc(true)))
        end
        available = false;
    else
        lastcheck = datetime(udout.last_check_at,'InputFormat','yyyy-MM-dd''T''HH:mm:ss''Z''',TimeZone='Z');
        if noisy
            disp(sprintf("ORaaS was up as of %s ago", nowutc(true)-lastcheck))
            disp(sprintf("Next check in %s", nextcheck-nowutc(true)))
        end
        available = true;
    end
end
