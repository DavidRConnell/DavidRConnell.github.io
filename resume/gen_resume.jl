using Printf: @printf
DATAPATH = "data.txt"

mutable struct Section
    name
    elements
    Section(name) = new(name, [])
end

mutable struct Education
    school
    location
    date
    degree
    program
    gpa
    classes
    Education() = new()
end

mutable struct Thesis
    description
    items
    Thesis() = new()
end

mutable struct Experience
    place
    position
    date
    department
    items
    exactdate
    Experience() = new()
end

mutable struct Languages
    list
    Languages() = new()
end

mutable struct Latex
    value
end

"Tokenize the data in file *file*. Lines starting with a # denote section
headers and are used to name the list of elements under the header. Elements are
separated by blank lines and fields marked by name: data.

Returns a list of sections which are in turn a list of elements. Elements are
predefined structures.

*Special characters*
%: separates items in a list.
...: switches from left to right justification for the remainder of the line.
Raw_Latex: Latex code that isn't altered in any way when being read. (Except \\N is used inplace of an actual line break)"
function tokenize(file)
    open(file, "r") do f
        sections = []
        currentsection = ""
        for ln in eachline(f)
            words = split(ln, " ")
            firstword = words[1]

            if firstword == "#"
                removeelement!(sections, currentsection)
                currentsection = join(words[2:end], " ")
                addsection!(sections, currentsection)
            elseif isempty(ln)
                addelement!(sections, currentsection)
            elseif endswith(firstword, ":")
                field = firstword[1:end-1]
                value = split(join(words[2:end], " "), "%")
                addfield!(sections, field, value)
            else
                @error "Syntax error in data file, %s" ln
            end
        end
        return(sections)
    end
end

function removeelement!(sections, sectionname)
    length(sections) > 0 || return
    pop!(sections[end].elements)
end

function addsection!(sections, sectionname)
    push!(sections, Section(sectionname))
    addelement!(sections, sectionname)
end

function addelement!(sections, sectionname)
    currentlist = sections[end].elements
    string2type = Dict("Education" => Education,
                       "Master Thesis" => Thesis,
                       "Experience" => Experience,
                       "Computer Languages" => Languages)

    push!(currentlist, string2type[sectionname]())
end

function addfield!(sections, field, value)
    currentelement = sections[end].elements[end]
    if field == "Raw_Latex"
        sections[end].elements[end] = Latex(value)
        return
    end
   
    field = Symbol(lowercase(field))
    eval(:($currentelement.$field = $value))
end

function latexexport(tokens)
    open("resume.tex", "w") do f
        str = writelatexpreamble()
        str *= beginlatexresume()
        for section in tokens
            str *= writesection(section, "latex")
        end
        str *= raw"

\end{document}"

        str = replace(str, "..." => raw"\hfill")
        @printf(f, "%s", str)
    end
end

function markdownexport(tokens)
    open("../resume.markdown", "w") do f
        str = writemarkdowntopmatter()
        str *= adddownloadbutton()
        for section in tokens
            str *= writesection(section, "markdown")
        end

        @printf(f, "%s", str)
    end
end

function writesection(section, filetype)
    if filetype == "latex"
        writelatexsection(section)
    else
        writemarkdownsection(section)
    end
end

function writeelement(element, filetype)
    if filetype == "latex"
        writelatexelement(element)
    else
        writemarkdownelement(element)
    end
end

# LaTeX functions
function writelatexpreamble()
    raw"\documentclass{resume}

\author{David R. Connell}
\email{\href{mailto:David\_R\_Connell@rush.edu}{david\_r\_connell@rush.edu}}
\link{\href{https://davidrconnell.github.io}{davidrconnell.github.io}}
\phone{614.558.1522}
\area{Chicago,~IL}

\renewcommand{\inputObjective}[1]{
    \begin{center}
        \textit{\input{#1}}\\[0.5em]
    \end{center}
}"
end

function beginlatexresume()
    raw"

\begin{document}
    \makeheader
    \inputObjective{objective}
"
end

function writelatexsection(section)
    str = "
    \\section{$(section.name)}"

    for element in section.elements
        str *= writeelement(element, "latex")
    end
    return str
end

function writelatexelement(element::Education)
    "
        \\education{$(element.degree[1]), $(element.program[1])}%
            {$(element.date[1])}%
            {$(element.school[1]), $(element.location[1])}%
            {$(element.gpa[1])}%
            {$(element.classes[1])}
"
end

function writelatexelement(element::Thesis)
    str = "
    \\textbf{$(element.description[1])}
    %
    \\begin{itemize}
        \\setlength{\\itemsep}{0pt}
        \\small{"

    for item in element.items
        str *= "
                \\item{$item}"
    end

    str *= "
            }
        \\end{itemize}
        \\vspace{5pt}
"
end

function writelatexelement(element::Experience)
    str = "
    \\experience%
        {$(element.position[1]): \\textit{$(element.place[1])}}%
        {$(element.date[1])}%
        {$(element.department[1])}%
        {%"
    for item in element.items
        str *= "
            \\item $item"
    end
    str *= "
        }
"
end

function writelatexelement(element::Languages)
    "
    " * element.list[1]
end

function writelatexelement(element::Latex)
    "
    " * join(split(element.value[1], raw"\N"), "\n    ") * "
"
end

# Markdown functions
function writemarkdowntopmatter()
    "---
title: Résumé
layout: default
---

"
end

function adddownloadbutton()
    "{% include button.html button_name=\"PDF Version\" button_class=\"outline-primary\" file=\"/downloads/resume.pdf\" %}"
end

function writemarkdownsection(section)
    str = "\n\n### $(section.name)\n"

    for element in section.elements
        isa(element, Latex) && continue
        str *= writeelement(element, "markdown")
    end
    return str
end

function writemarkdownelement(element::Education)
    "**$(element.degree[1]), $(element.program[1])**" *
    rightalign("**$(element.date[1])**") *
    "\n#### $(element.school[1]), $(element.location[1])" *
    "\n#### GPA: $(element.gpa[1])\n\n"
end

function writemarkdownelement(element::Thesis)
    "**$(element.description[1])**\n\n"
end

function writemarkdownelement(element::Experience)
    "**$(element.position[1])**" *
    rightalign("**$(element.date[1])**") *
    "\n#### $(element.place[1])" *
    "\n#### $(element.department[1])\n\n"
end

function writemarkdownelement(element::Languages)
    replace(element.list[1], raw"\LaTeX" => "LaTeX")
end

function rightalign(text)
    "{% marginnote \'mn-id-$text\' \'<span style=\"font-size: 110%\">$text</span>\'%}"
end

function alignatdots(text)
    str = ""
    for (i, s) in enumerate(split(text, "... "))
        if iseven(i)
            str *= rightalign(s)
        else
            str *= s
        end
    end
    return str
end

# Main
tokens = tokenize(DATAPATH)
latexexport(tokens)
markdownexport(tokens)
