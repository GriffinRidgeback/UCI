# UCI
This repository contains the project work done for my course Getting and Cleaning Data


[Hadley Wickham's paper on Tidy Data] (http://www.jstatsoft.org/v59/i10/paper)
[David's personal course project FAQ] (https://class.coursera.org/getdata-030/forum/thread?thread_id=37)
[Tidy Data and the Assignment] (https://class.coursera.org/getdata-030/forum/thread?thread_id=107)

Tidy data is not made to be looked neatly at in programs like notepad (which is often the default for text files on windows), but if you saved the file with write.table according to the instructions, the command for reading it in and looking at it in R would be

    data <- read.table(file_path, header = TRUE) #if they used some other way of saving the file than a default write.table, this step will be different
    View(data)
    
   
   Over in the FAQ thread I mentioned people could put the code for reading the tidy data into R into their readMe

But if you want to get fancier than that:

If you right click on a file name in the submission box and copy the web address, you can paste it into a script.

   address <- "https://s3.amazonaws.com/coursera-uploads/user-longmysteriouscode/asst-3/massivelongcode.csv"
address <- sub("^https", "http", address)
data <- read.table(url(address), header = TRUE) #if they used some other way of saving the file than a default write.table, this step will be different
View(data)