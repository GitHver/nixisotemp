
# Git basics

With everything being configured and controlled through text files, you may have realised that storing/backing-up your system can be easy and space efficient. You might have also noticed that when you revert to a previous configuration, your configuration files don't revert to the state of the current configuration, so in order to build upon your previous working configuration, you'll need to remember what was changed and revert to that state manually. This is not realistically achievable for any normal person, and so we need better solution to manage the versions of our configuration files.

### Git Version control

Git is a software version-control program. This means that it keeps track of files and any changes made to them. It takes snapshots of your repository when you make a commit allowing you to revert to that state of if you make any breaking changes. These snapshot also only keep the changes made each commit, so it stores no unnecessary information. Git also supports multiple *branching* development environments, allowing for different features to be made and tested in separate commits, which can be eventually be merged allowing all features to be pushed without conflict, even if all branches made changes to the same file as long as no one line was altered in two different ways.

Since Git is a *software* version control program, it is perfect for your configuration files. After all, Nix is a programming language, and your configuration files all amount to a small program. The way in which NixOS is used is also similar to 'code as infrastructure', so while you may not find configuring your system to be all to similar to "actual" programming, the skills you gain from Nix are all transferable to any programming environment.

### Initialising a Git repository

The repository you downloaded (this repository) has its own git directory named `git`. You can't see it as it's name starts with a dot, making it a hidden file. to see, you can use `ls -a`, `eza -a` or you can press `.` while in `yazi` to display all hidden files. Since you are here to learn git, you're going to delete the current repository and initialise a new one. In your terminal, put the following: `rm -r .git`, then use `git init`.

This will initialise a new git repository in your directory. you will automatically be on the `master` branch as that is the main and only branch. if you wish to rename it, you can use `git branch -m master release`. This will rename the specified branch (`master`) to the new name (`release`).

### Adding & removing files

You'll need to add the files you want to be tracked to the repository. You can do this with `git add name-of.file` . This will add the specified file to be tracked by git. If you want to add all files to be tracked, you can use `git add .`. to remove files, like ones you are planning to add later, or ones that just should not be tracked, use `git rm name-of.file`.

There are some files you never want to add to your repository, like temporary files, or build/compiled directories and binaries. To avoid having to remove them from tracking every time you want to make a commit, you can instead use a `.gitignore` file to list all files you don't want to be tracked.

There already is a `.gitignore` file in the repository that ignores all result/ directories. These are the directories that come when you use `nix build` to pre build something or when you make an ISO, so you don't need to change anything, but for your reference there is an explanation of all the syntax for making `.gitignore` files in the `.gitignore` file if you ever need to add something else.

### Committing changes

Git has no automatic saving, as it uses the difference between each version to save, a as such needs you to determine when to make a snapshot of the repository. To do this you use commits. You can think of each commit as a new version release of your system. Each time you make a change or add a feature you want to save before moving on to the next thing, you make a commit to save the current version to start working on the next version.

after you've added all the files you need to save, type `git commmit` in your terminal and you will be put into your current text editor where you need to write a comment about the current commit. E.x: "Changed the readme file to more accurately reflect the installation process". you can also use `git commit -m 'message'` to put the message you want without opening up the text editor. Just replace `message` with your message and the commit will go through.

To revert to a previous commit you can use `git reset commithash` where `commithash` is the hash of the commit you want to revert to. To find out what the hash of any commit is you can use `git log` and copy the hash or just use the first few characters, as it is very unlikely that any two commit have the same starting characters, and gets exponentially more unlikely with each character, so the first ~7 should do and git will automatically find the commit that matches those characters. This would look something like this: `git commit ca49d82`.

you can also use `git reset --soft commithash` to keep the changes made in the current directory. `git reset --hard commithash` discards all changes made in the directory effectively reverting the repository to the specified commit.

If you want to see the difference between your current directory and the last commit, you use `git diff HEAD`, and to see the difference between two commits, you can use `git diff commit1hash commit2hash`.

You can see more information about the current commit with `git show`, and to get information about any specific commit you simply add the commit hash at the end like so: `git show 48ddad7`.

`git restore name-of.file` restores a file to the state of the current commit effectively discarding all changes.

### Branching out

When working on many features and changes at once, it can be difficult do test them if they're all in the same staging area. With branches you can *branch* out your development environments. This way you can have many different versions going at the same time with out any interfering with the other or making breaking changes with out knowing which change is causing it.

By using `git branch testing` you make a new branch with the name `testing`, but you can name it whatever you want. Since you made this branch from the `master` branch, or whatever name you gave your main branch, the new branch will inherit the commit history from it, making them two branches currently identical. Using `git branch`, you get a list of  all current branches. To switch to a different branch use `git checkout branchname`, with `branchname` being the name of the branch to switch to.

In the new branch you can make changes and add or remove files and make as many commits as you want, but eventually you'll want to add all the new changes to your main branch. you can do this by going to the main branch and using `git merge branchname`. This will merge newest commit of the specified branch to the current one.

Now the two branches should be identical (unless you have made any changes to your main branch like commits or merges of other branches), except in their commit history. If you are using this branch as a testing environment before merging with the main branch, the you will probably be keeping the branch. But if the branch you made was for a specific feature, then it is probably not needed anymore and by using `git branch -d branchname` you can delete the specified branch from the repository.

### GitUI

GItUI is a program that brings a UI to your git workflow. you can use it to check logs in a more easily accessible manner. You can even make all your commits and merges from here. It is an invaluable tool, but not every computer you will use will have it, so it is best to get a bit used to using git from the commandline before starting to integrate on GitUI into your workflow. To use GitUI, just type  `gitui` while in the root directory of the git repository.

### Adding a remote repository

After all this you might want a place to store your repository, so that you can fetch it from anywhere, and should anything happen to your computer, it won't be lost forever.

There are many ways to do this, including hosting your own server, but for most people, it's best to use some established git hoster, like GitHub or GitLabs. If you want to use any of them, simply go to those sites and look for how to make a new repository. Once that's done you can use  `git remote add <name> <url>` to add that repository as a remote.

Once you have a remote repository, you can use `git push` to push all changes you've made to the remote repository. `git fetch` fetches all changes from the remote, for if you have made any changes on another machine or on the site itself. `git pull` fetches all changes from the remote and automatically merges them (beware of any possible merge conflicts). On a new machine you can use `git clone url` to copy the repository to the new machine.

### More documentation

This should be well enough for most everything you will need to do with git. There are some more things such as notes and tags, advanced shortcut commands and some general concepts on how version control works under the hood, but for now this should suffice. If you ever need to learn anything more, simply checkout the [git documentation](https://git-scm.com/docs/git) or just search up a git cheat sheet if you need a refresher on available commands.

# Next

[Configuration](./configuration.md)