# Installation Instructions

1. Unzip the ADVISOR executable to the folder of your choice
2. Start MATLAB and change your current (active) directory 
   to be the top-level ADVISOR directory from step 1.
3. To run ADVISOR, type advisor at the MATLAB command prompt.

Note: ADVISOR now automatically adds the necessary paths beyond the 
top-level ADVISOR directory and gives the option of saving these paths 
so they do not need to be added the next time. 

Direct any questions to our on-line Google Group at:

https://groups.google.com/group/adv-vehicle-sim


# Building the ADVISOR Documentation

ADVISOR does not require any building or compilation steps. Furthermore,
we ship all ADVISOR documentation as HTML located in the documentation
directory. However, for advanced users or ADVISOR developers, please note
that we are in the process of transitioning the ADVISOR documentation over
to a [Markdown](http://daringfireball.net/projects/markdown/) format.

Processing the markdown files into HTML requires a recent versions of Ruby,
Rake, and Pandoc to be installed. Because the installation of Ruby, Rake,
and Pandoc is an advanced topic, we will continue to provide both raw
markdown files and the generated HTML files.

However, should you want to build the documentation, the following versions
of Ruby, Rake, and Pandoc are recommended:

* [Ruby >= 2.0.0p0](http://www.ruby-lang.org/en/downloads/)
* [Rake >= 10.0.3](http://rake.rubyforge.org/) -- use "gem install rake"
* [Pandoc >= 1.10.1](http://johnmacfarlane.net/pandoc/index.html)

To create HTML from the markdown files, change to the documentation
directory. From the command line type "rake gen_html". For a list of
additional rake tasks, type "rake -T".

-- The ADVISOR Team