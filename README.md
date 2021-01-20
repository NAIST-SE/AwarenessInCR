# Dataset Package:


This is a dataset for the paper **Understanding Shared Links and Their Intentions to Meet Information Needs in Modern Code Review**.//
This artifact is a repository consisting of (i) raw dataset (ii) labeled link targets and their intentions, and (iii) script for the statistical model

## Abstract:
Code reviews serve as a quality assurance activity for software teams. Especially for Modern Code Review, sharing a link during a review discussion serves as an effective awareness mechanism where “Code reviews are good FYIs[for your information].”Although prior work has explored link sharing and the information needs of a code review, the extent to which links are used to properly conduct a review is unknown. In this study, we performed a mixed-method approach to investigate the practice of link sharing and their intentions. First, through a quantitative study of the OpenStack and Qt ecosystems, we identify19,268 patches that have 39,686 links to explore the extent to which the links are shared, and analyze a correlation between link sharing and review time. Then in a qualitative study, we analyze 400 links to understand the role and usefulness of link sharing. Results indicate that internal links are more widely referred to(93% and 80% for the two ecosystems). Importantly, although the majority of the internal links are referencing to patches, bug reports and source code are also shared in review discussions. The statistical models show that the number of internal links as an explanatory factor does have an increasing relationship with the review time. Finally, we present seven intentions of link sharing, with the context understanding being the most commonly used. To conduct a proper review, we encourage the patch author to provide clear context and explore both internal and external resources, while the review team should continue link sharing activities. Future research directions include the investigation of causality between sharing links and the review process, as well as the potential for tool support.

## Finding I Summary:
In the past five years, 25% and 20% of the patches have at least one link shared in a review discussion within the OpenStack and Qt.
93% and 80% of shared links are the internal links that are directly related to the ecosystem.
Importantly, although the majority of the internal links are referencing to patches, we find that the links referencing to bug reports and source code are also shared in review discussions.
In addition, we find that the common target types of external links are tutorial and API documentation.

## Finding II Summary:
Our non-linear regression models show that the internal link has a significant correlation (but relatively weak) with the patch review time. However, the external link is not significantly correlated with the patch review time.
Furthermore, we observe that the number of internal links has an increasing relationship with the patch review time.

## Finding III Summary:
We identify seven intentions of sharing links: (1) Providing Context, (2) Elaborating, (3) Clarifying, (4) Explaining Necessity, (5) Proposing Improvement, (6) Suggesting Experts, and (7) Informing Splitted Request.
We find that providing context is the most common intention for sharing internal links and elaborating (i.e., providing a reference or related information) to complement review comments is the most common intention for sharing external links.

## Contents
* `Labeled dataset` - the labeled link targets and their intentions.
* `Raw dataset` - the raw dataset for OpenStack and Qt [Dropbox](https://www.dropbox.com/sh/swrpxfexi6ggrm8/AADDToxZfiLz7tY9PAoA3zdTa?dl=0) 
* `Statistical_model` - including the computed metrics for OpenStack and Qt, and the R script for the statistical models
* `README.md` - the description for each file.


## Authors
* [Dong Wang](https://dong-w.github.io/) - Nara Institute of Science and Technology, Japan
* Tao Xiao - Nara Institute of Science and Technology, Japan
* [Patanamon Thongtanunam](http://patanamon.com/) - The University of Melbourne, Australia
* [Raula Gaikovina Kula](https://raux.github.io/) - Nara Institute of Science and Technology, Japan
* Kenichi Matsumoto - Nara Institute of Science and Technology, Japan

Our dataset are published on the public domain, so that anyone may freely build upon, enhance and reuse the dataset for any purposes without restriction under copyright or database law.
