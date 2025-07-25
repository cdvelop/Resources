You are an expert in creating educational assessments. Your task is to generate exam questions based on the provided Markdown files. These Markdown files detail activities that students have completed.

The goal of the exam is to assess the specific knowledge and understanding students should have gained from performing these activities.

**Instructions for question generation:**

1.  **Source Material:** The content for the questions must be derived *exclusively* from the student activities described in the Markdown files that will be provided after this initial instruction.
2.  **Knowledge Focus:** Identify the key concepts, skills, tools, and procedures students should have learned or utilized while performing the activities in the provided Markdown files. Questions should target this acquired knowledge.
3.  **Question Types:** Generate a mix of the following question types suitable for automated evaluation, based on the content of the provided Markdown files:
    *   Multiple Choice (MC)
    *   True/False (TF)
    *   Fill in the Blank (FIB)
    *   Matching (MAT)
    *   Numeric Response (NUM)
    (Prioritize MC, TF, and FIB if the content is more suited to them.)
4.  **Format:** All questions must strictly adhere to the tab-delimited TXT format specified in the `blackboard.md` content below.
5.  **Output:** Produce a single, plain text, tab-delimited file. Each line should represent one question formatted as per the `blackboard.md` guidelines. Do not include headers or blank lines.

**Reference: `blackboard.md` content (for question formatting):**
```markdown
# BlackBoard Question Upload Format

## Requirements
- Tab-delimited TXT file
- Max 500 records per file
- No header row, no blank lines
- One question per row
- First field = question type
- Answer keywords in English: correct|incorrect|true|false

## Question Types & Format

| Type | Format |
|------|--------|
| MC | `MC TAB question TAB answer1 TAB correct\|incorrect TAB answer2 TAB correct\|incorrect` |
| MA | `MA TAB question TAB answer1 TAB correct\|incorrect TAB answer2 TAB correct\|incorrect` |
| TF | `TF TAB question TAB true\|false` |
| ESS | `ESS TAB question TAB [example]` |
| ORD | `ORD TAB question TAB answer1 TAB answer2` |
| MAT | `MAT TAB question TAB answer1 TAB match1 TAB answer2 TAB match2` |
| FIB | `FIB TAB question TAB answer1 TAB answer2` |
| FIB_PLUS | `FIB_PLUS TAB question TAB var1 TAB ans1 TAB ans2 TAB TAB var2 TAB ans3` |
| NUM | `NUM TAB question TAB answer TAB tolerance` |
| SR | `SR TAB question TAB sample_answer` |


```

| Question Type            | Structure                                                                                                               |
|--------------------------|-------------------------------------------------------------------------------------------------------------------------|
| Multiple Choice          | `MC TAB question text TAB answer text TAB correct|incorrect TAB answer two text TAB correct|incorrect`                 |
| Multiple Answer          | `MA TAB question text TAB answer text TAB correct|incorrect TAB answer two text TAB correct|incorrect`                 |
| True/False               | `TF TAB question text TAB true|false`                                                                                  |
| Essay                    | `ESS TAB question text TAB [example]`                                                                                   |
| Ordering                 | `ORD TAB question text TAB answer text TAB answer two text`                                                             |
| Matching                 | `MAT TAB question text TAB answer text TAB matching text TAB answer two text TAB matching two text`                     |
| Fill in the Blank        | `FIB TAB question text TAB answer text TAB answer two text`                                                             |
| Fill in Multiple Blanks  | `FIB_PLUS TAB question text TAB variable1 TAB answer1 TAB answer2 TAB  TAB variable2 TAB answer3`                       |
| File Response            | `FIL TAB question text`                                                                                                 |
| Numeric Response         | `NUM TAB question text TAB answer TAB [optional] tolerance`                                                             |
| Short Answer             | `SR TAB question text TAB sample answer`                                                                                |
| Opinion/Likert Scale     | `OP TAB question text`                                                                                                  |
| Jumbled Sentence         | `JUMBLED_SENTENCE TAB question text TAB choice1 TAB variable1 TAB choice2 TAB  TAB choice3 TAB variable2`               |
| Quiz Bowl                | `QUIZ_BOWL TAB question text TAB question_word1 TAB question_word2 TAB phrase1 TAB phrase2`                             |



## tsv example
```tsv
Type	Question	Answer1	Status1	Answer2	Status2	Answer3	Status3	Answer4	Status4	Answer5	Status5
MC	Which ocean is the warmest?	Atlantic	correct	Pacific	incorrect	Arctic	incorrect			
MA	Choose all of the examples or types of carbohydrates	Galactose	correct	Fructose	correct	Melanin	incorrect	Sucrose	correct	
TF	Blaise Pascal was a 20th century sociologist who argued for the importance of identifying scientific laws that govern human behavior.	false				
ESS	Give a few examples where you can help preserve marine ecosystems.	[Placeholder essay text]				
MAT	Match the following animals to their native continent	Bullfrog	North America	Panda	Asia	Llama	South America
FIB	___ is the silicate mineral with the lowest melting temperature and the greatest resistance to weathering.	Quartz				
FIB_PLUS	"Four [a] and [b] years ago" is the beginning of the [c] delivered by [d].	a	score	b	seven	c	Gettysburg Address	d	Abraham Lincoln
NUM	Approximately, how many species of birds are there?	10,000	1000
```


---
**Now, paste the content of your Markdown README files (the student activities) below this line for the LLM to

