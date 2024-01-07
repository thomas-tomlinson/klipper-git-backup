# Klipper config git backup

This is a minimal script to backup klipper config files to a github repo.  It's
nothing fancy, designed to run via a crontab entry on the local host and maybe
save your bacon.

I created this for a raspberry PI install with mainsail OS.  

## Setup

* in the home directory of your klipper user, checkout out the repo 

```
git clone https://github.com/thomas-tomlinson/klipper-git-backup.git
```

* Add the following to the moonraker.cfg file and restart moonraker.  

```
# klipper git backup script
[update_manager klipper-git-backup]
type: git_repo
path: ~/klipper-git-backup
origin: https://github.com/thomas-tomlinson/klipper-git-backup.git
is_system_service: False
primary_branch: main
```

* Login to your klipper host as the klipper user (usually pi if your running
  mainsail OS) and create a directory called [git_backup.  i.e. mkdir
  ~/git_backup.

* If you haven't already, create a ssh key for your klipper user.  If you see
  files beginning with id_ in the .ssh directory of your klipper user, you
  probably already have these.  if not, run the command [ssh-keygen] and accept
  all of the defaults.  We're going to need the one that ends in .pub.  Keep
  the file name in mind.

* Create a github repo for your machine's backups.  You can name this anything
  you want want, it just needs to be unique to your printer.  Make this a
  public repo (nothing to hide here).  Leave the "Add a README file" unselected
  and leave the rest as defaults.

  Next, click on the "Settings" tab for your newly created repo.  Click on the
  "Deploy keys" under security on the left hand side.  Click add deploy key.
  now we'll make use of the ssh public key you may have just created.  You can
  provide any title you want for the key (it's just a label).  Next you'll need
  to add the klipper's users public key.  Almost always for a raspberry pi
  mainsail OS install you can run this command while logged in to the pi.
   
```
cat ~/.ssh/id_rsa.pub
```
  Take that output and add it to the section titled "Key".  Make sure you click
  the "allow write access" button.  and then hit the "add key" button.  Lastly,
  if you click on the name of your new repo (very top left of the browser
  window), if will return you to the main screen of your repo with the initial
  setup directions.  you'll wants this in front of you for the next step.

* Back on your klipper host as the klipper user, cd into the git_backup
  directory [cd ~/git_backup].  Now, we're going to follow the Quick setup
  guide.  Click the "SSH" button right under the Quick Setup and the directions
  will be cut and paste to get the repo up and running.  For me, i would do the
  following on a new repo i created while building these directions:
  NOTE: if you're an experienced git/ssh/linux person, feel free to init the
  repo any way you wish.
```
echo "# test-klipper-backup" >> README.md
git init
git add README.md
git commit -m "first commit"
git branch -M main
git remote add origin git@github.com:thomas-tomlinson/test-klipper-backup.git
git push -u origin main
```
You'll be prompted add the host key of the remote repo, answer yes to this.

* Now we can execute a manual backup just by running the script with is command
```
~/klipper-git-backup/backup_klipper_config.sh
```

This will make the first copy of the config files to the git_backup directory
and push them up to the new repo.

* if you want to run this on a schedule, you can add an entry like this to the
  crontab of the klipper user (assumes you running this on a raspberry pi.
  replace the "/home/pi" prefix if your klipper host is different)

```
0 0 * * * /home/pi/klipper-git-backup/backup_klipper_config.sh 2>&1 >/dev/null
```







