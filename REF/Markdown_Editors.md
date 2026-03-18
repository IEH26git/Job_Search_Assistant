# Fun Pre-Reading

**[Simple, Non-Commercial, Open Source Notes](https://youtu.be/XRpHIa-2XCE?si=NT2Fpk-wSxgmJkwS)**

---

## QOwnNotes

**https://www.qownnotes.org/**

My favorite. Most powerful option. Open source and free.

---

## MarkEdit

**https://github.com/MarkEdit-app**
MarkEdit **[Manual](https://github.com/MarkEdit-app/MarkEdit/wiki/Manual)**  
https://github.com/MarkEdit-app/MarkEdit/wiki/Customization
https://github.com/MarkEdit-app/MarkEdit-theme-duotone
> **For viewing HTML preview side by side with editor, use [MarkEdit-preview](https://github.com/MarkEdit-app/MarkEdit-preview)**

Open source and free.

_The quick brown fox jumped over the lazy dog._
The quick brown fox jumped over the lazy dog. 

### MarkEdit Notes
MarkEdit: Write the date/time to insert date and time

``` Markdown: Type <Globe key> and search for/select <Place of Interest> to get the <Command> icon ⌘
```

---

## Typewriter

[Typewriter markdown editor](https://eightysix.github.io/)

> **Fun Fact:** The Typewriter app for Mac does not support typewriter mode!

Does this do _markdown_?  
* Yes, sort of.  
1. Number 1
2. Number 2

You can type the Mac Command symbol (⌘) by inserting the Place of Interest sign (aka command symbol) from the Emoji's & Symbols panel.
Enter the word ‘place’ in the search window. 
Click the ⌘ symbol to insert it at the current insertion point in your document.
⌘

***
<!-- Three asterisks on one line (followed by a carriage return) make a horizontal rule-->
=== 
```These --> (===) do nothing
```

```Code comment (add tick marks to close)
```
---  
<!-- Three dashes on one line (followed by a carriage return) make a horizontal rule-->

- [ ] Checkbox
- [x] Box checked (toggles in editor, not in preview)
---

# Heading 1 
## Heading 2
### Heading 3
#### Heading 4
##### Heading 5

# Syntax highlighting 
*Italics*  
**Bold**  
***Bold italics***  
`Inline Code`  
[Link](https://mrchromebox.tech) 
![From web site:](syntax-highlighting.png)
 

<!-- Quote and footnotes. -->
> Quote with footnote [^text]  
> Another quote with footnote [^quote]

<!-- This is a test for other formats. -->

```Label for code in fences
```

> This is another test.

```
This is code that is set off by fences. 
```

`This format is inline code`  
    This is indented code  (four spaces or a tab press; two spaces at end creates a carriage return)  
This is not indented code

---

    “indented code”
    Why does this show code with different text highlights?
> In the Typewriter app for Mac (and most Markdown-based editors), putting a tab or four spaces at the beginning of a line triggers a specific formatting rule called a Code Block or Indented Code. Here is why your text format is changing:
> 1. Markdown Syntax. Typewriter is a Markdown editor. In standard Markdown, any line that begins with at least four spaces or one tab is interpreted as "pre-formatted text" or code. The app assumes you are trying to write programming code (like Python or HTML) and changes the text style to reflect that.
> 2. Monospaced Font. When you trigger this "Code Mode," the app usually switches the font to a monospaced font (like Courier or Menlo) where every character takes up the same amount of width. This is standard for code but looks different from your regular "Body" text.
> 3. Syntax Highlighting. Because it thinks you're writing code, it may also change the color of certain words (like "if," "the," or "and") if they happen to match keywords in a programming language.

**How to Fix or Avoid This**  
If you just want to indent a paragraph without changing the text format, you have a few options:

1. Don't use Tabs for Indents. Use two returns (an empty line) between paragraphs rather than indenting the first line.
2. Open Typewriter > Settings (or Preferences) and look for an option to disable "Indented Code Blocks" or "Auto-formatting," though this may not be available in all Markdown-specific apps.
3. If you are trying to create a list, use a hyphen (- ) or an asterisk (* ) followed by a space instead.

_If you're using this app specifically because you like the "Typewriter Mode" (where the active line stays centered), you might find that using the Space bar for a smaller indent doesn't trigger the code block as long as you stay under four spaces._

```This is not inline code
```

[^text]: description
[^quote]: different description