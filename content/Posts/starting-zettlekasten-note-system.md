---
title: My Zettlekasten
date: 2025-01-11
draft: false
tags:
  - coding
---
# Zettlekasten note taking system: First approach and review.

## How the idea of note taking was conceived

At first, I started taking notes on paper since 2023 in an informal manner. I noticed that I became dependent on them, more so than I expected at first always searching for notes i didn't record and learnings I must have forgotten because of my long-term retention capacity. Finally this year (2024), I decided to commit myself to have a formal approach on note taking.

As I was searching for references on my investigation, a nice reference was found of a particular devops self-thought man previously a nurse and out of passion of being a "knowledge worker" became a developer operations engineer. This man's name is ["Mischa van den Burg"](https://mischavandenburg.com/). He has a zettlekasten system on his own, and I decided to follow his steps and set up my own based in some of the features he developed.

## Choosing some tools

I found myself always craving for `frictionless feature`, even for note taking. A `frictionless feature` is a tool, routine or any sort of idea that makes my life easier without putting a lot of effort on learning the habit of it. It should feel like it was always required and when you manage to do it; it should feel like it always was there.

For me, a `frictionless feature` at first was the white paper approach. The mental effort for *recording new findings* and information is non existent and is flexibility is impressive (adding color pencils feels great!). But the white paper approach really lacked in the *recovering mechanism*. For this same reason I manage to create a better automatized approach using Neovim fuzzy finder features + Obsidian's graph viewer.

Neovim is a great IDE for development mostly but can be configure to search between notes and making great experience for writing code. Since I have a developer background I decided to create a "Neovim note taking system" approach based on what Mischa van den Burg suggested himself. Obsidian was a note taking system that has interesting graphical plugins and visualizations, that will provide more aesthetic note visualizations.

### Removing friction for the note taking system

Once I had figured out which tools would be useful for the system, I had to reduce as much friction as possible. `Friction` for me, is the antagonist of proactivity. Reducing effort contributes to creating action, by facilitating the person to not stall through tedious routines. 

A easy technical solution for reducing the undesirable friction was to create a serious of small automatization around the interaction specifically of creating notes. The biggest gap I thought needed to be attended as soon as possible was the _recording new findings_ mechanism. Opening an application is a major friction point for me as a user, so creating a `shortcut` for it that will create a note structure with an specific `unique identifier` per note is valuable.

As a solution, I manage to investigate a proper automatized small system with `bash files`. For this system, my  previous experience had thought me that many bash files tend to entropy real quick. Given that a good solution, most be maintainable and understandable for a long time, I decided to create a personal folder for all `dotfiles` solution. A dotfile based on what is posted on [Github dotfile topic](https://github.com/topics/dotfiles?o=desc&s=updated) it is:

> Legend goes, that dotfiles were invented when ls used to skip files and directories starting with a . (dot). As a result, files that begin with such a character were not shown when listing using ls — i.e. it was a "hidden" file. Since dotfiles are ususually user-specific, a predestined place for them is the $HOME directory. Commonly used files are for example: `.bashrc`, `.zshrc` or `.vimrc`.

## Defining a documentation strategy

> Taking notes is to live with intention - Mischa van den Burg

I am a forgetful person, and I am in a moment in my life were ideas are a big part of me. This quote above, resonated with how i felt for the longest time, forgetting was a painful act in itself since valuable thoughts you cherish suddenly banish and you don't notice them when they go away. I want to record thoughts, they don't need to have an specific structure or make much sense but I want to be the craftsman of my empire of ideas.

### The PARA method: An informal idea of indexing logs

For the PARA methods, it is a simple note taking system, that creates a couple of concepts around how files should be ordered into a limited categories of folders. This folder are the (P)rojects, (A)reas, (R)esources, (A)rchives. Each of them has a use:

+ Projects: "A project is a sequence of tasks you need to accomplish in order to achieve a certain outcome - David Allan" (3 months - 12 months)

+ Areas: It involves ongoing engagements. It places a particular important role in your life. Are areas particularly important to your life like health, sports, family, ...

+ Resources: Is a collection of information, that you expect to be useful. It can be hobbies, investigations, interests, ...

+ Archive: Searching for notes, old notes will appear and you make connections. This is information can be logged as "old", but could appear on a search for a helping hand some day.

### What is the origin of a log (small story)

> A log started life as a lump of wood such as you might throw on a fire. And it still is - sometimes. When sailors wanted to know how fast they were going, they would throw over the stern a log tied to a bit of string with regularly spaced knots in it. By counting the number of knots that went out in a fixed time, they would know their speed - in knots, of course. A navigator would want to have a regular record of this speed, so that he could calculate how fast the ship was travelling than thus roughly where he was. So the speed was written down, initially on a slate but later in a book, which, since it recorded the log measurements, was called the log. - By [Alec Cawley](https://www.quora.com/Why-are-computer-logfiles-called-so)


Links: [[Notes]] [[Research]]

[My Neovim Zettelkasten - Mischa van den Burg](https://mischavandenburg.com/zet/neovim-zettelkasten/)

[Dotfiles - Rob Muhlestein (rwxrob)](https://rwx.gg/tools/linux/tasks/dotfiles/bash/)

[Github dotfiles](https://dotfiles.github.io/)

[Dotfiles Webpro - Lars Kappert](https://www.webpro.nl/articles/getting-started-with-dotfiles)

202408101453
