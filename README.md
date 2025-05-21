# UBKGBox

<img width="212" alt="image" src="https://github.com/user-attachments/assets/815336f4-4ae0-40e6-8b10-511250d213dd" />

This repository describes **UBKGBox**: a self-contained, networked UBKG environment featuring:
- an instance of a UBKG context running in neo4j, built from the [ubkg-neo4j](https://github.com/x-atlas-consortia/ubkg-neo4j) Docker architecture
- client applications that work with the UBKG instance, including:
   - an instance of the UBKG API (https://github.com/x-atlas-consortia/ubkg-api), a REST API
   - Swagger documentation for the UBKG API
   - an instance of [Guesdt](https://github.com/x-atlas-consortia/Guesdt), a Web UI that represents the UBKG in tree view
   - the neo4j browser
- a home page with links to the client applications as well as the [UBKG Documentation](https://ubkg.docs.xconsortia.org/) site.

**UBKGBox** consolidates components with source from different GitHub repositories. Although the component repositories will provide some documentation regarding
integration into **UBKGBox**, this repository serves as the central documentation source.

# Obtaining UBKGBox
**UBKGBox** is distributed as a Zip file that can be downloaded from the [UBKG Download](https://ubkg-downloads.xconsortia.org/) site. 
_Additional instructions pending_

# UBKGBox Architecture

**UBKGBox** deploys as a Docker Compose multi-container application. Once the distribution is unzipped, executing a Shell script will instantiate **UBKGBox** on the host machine. 

The host machine will only need to be running Docker.

![image](https://github.com/user-attachments/assets/676221c4-0f93-42b8-b539-596282f8d510)

# Building a UBKGBox instance
## ubkg-front-end image
The **ubkg-front-end** image is published to the Docker Hub repository named **hubmap/ubkg-front-end**. Instructions for building and pushing the image are in the ubkg-api repo (_link after branch merge_).

