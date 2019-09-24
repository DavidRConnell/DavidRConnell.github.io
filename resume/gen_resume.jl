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
seperated by blank lines and fields marked by name: data.

Returns a list of sections which are in turn a list of elements. Elements are
predefined structures.

*Special characters*
%: seperates items in a list.
...: switches from left to right justification for the remaider of the line.
Raw_Latex: Latex code that isn't altered in any way when being read. (Except \N is used inplace of an actual line break)"
function tokenize(file)
    open(file, "r") do f
        sections = []
        currentsection = ""
        for ln in eachline(f)
            words = split(ln, " ")
            firstword = words[1]

            if firstword == "#"
                removesection!(sections, currentsection)
                currentsection = join(words[2:end], " ")
                addsection!(sections, currentsection)
            elseif firstword == ""
                addelement!(sections, currentsection)
            elseif firstword[end:end] == ":"
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

function removesection!(sections, sectionname)
    length(sections) > 0 || return
    pop!(sections[end].elements)
end

function addsection!(sections, sectionname)
    push!(sections, Section(sectionname))
    addelement!(sections, sectionname)
end

function addelement!(sections, sectionname)
    currentlist = sections[end].elements

    if sectionname == "Education"
        push!(currentlist, Education())
    elseif sectionname == "Master Thesis"
        push!(currentlist, Thesis())
    elseif sectionname == "Experience"
        push!(currentlist, Experience())
    elseif sectionname == "Computer Languages"
        push!(currentlist, Languages())
    else
        @error "Not a known section"
    end
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
        str = writepreamble()
        str *= beginresume()
        for section in tokens
            str *= writesection(section)
        end
        str *= raw"

\end{document}"

        str = replace(str, "..." => raw"\hfill")
        @printf(f, "%s", str)
    end
end

function writepreamble()
    raw"\documentclass{resume}

\author{David R. Connell}
\email{david\_r\_connell@rush.edu}
\link{davidrconnell.github.io}
\phone{614.558.1522}
\area{Chicago,~IL}

\renewcommand{\inputObjective}[1]{
    \begin{center}
        \textit{\input{#1}}\\[0.5em]
    \end{center}
}"
end

function beginresume()
    raw"

\begin{document}
    \makeheader
    \inputObjective{objective}
"
end

function writesection(section)
    str = "
    \\section{$(section.name)}"

    for element in section.elements
        str *= writeelements(element)
    end
    return str
end

function writeelements(element::Education)
    "
        \\education{$(element.degree[1]), $(element.program[1])}%
            {$(element.date[1])}%
            {$(element.school[1]), $(element.location[1])}%
            {$(element.gpa[1])}%
            {$(element.classes[1])}
"
end

function writeelements(element::Thesis)
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

function writeelements(element::Experience)
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

function writeelements(element::Languages)
    "
    " * element.list[1]
end

function writeelements(element::Latex)
    "
    " * join(split(element.value[1], raw"\N"), "\n    ") * "
"
end

# function markdownexport(tokens)
#     open(resume.markdown, "w") do f
#     end
# end

tokens = tokenize(DATAPATH)
latexexport(tokens)
# markdownexport(tokens)

# @info s[1].elements[1].location
