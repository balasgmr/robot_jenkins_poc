*** Settings ***
Library    RequestsLibrary
Library    Collections
Library    BuiltIn

Suite Setup       Create Session    jsonplaceholder    https://jsonplaceholder.typicode.com
Suite Teardown    Delete All Sessions

*** Variables ***
${resource}    /posts

*** Test Cases ***

Get All Posts
    ${response}=    GET On Session    jsonplaceholder    ${resource}
    Should Be Equal As Integers    ${response.status_code}    200
    ${body}=    Set Variable    ${response.json()}
    ${count}=    Get Length    ${body}
    Should Be True    ${count} > 0    msg=Expected more than 0 posts, but got ${count}

Get Single Post
    ${response}=    GET On Session    jsonplaceholder    ${resource}/1
    Should Be Equal As Integers    ${response.status_code}    200
    ${body}=    Set Variable    ${response.json()}
    Should Be Equal As Integers    ${body['id']}    1

Create Post
    ${data}=    Create Dictionary    title=new post    body=new content    userId=2
    ${response}=    POST On Session    jsonplaceholder    ${resource}    json=${data}
    Should Be Equal As Integers    ${response.status_code}    201
    ${body}=    Set Variable    ${response.json()}
    Should Be Equal As Strings     ${body['title']}    new post

Update Post
    ${data}=    Create Dictionary    id=2    title=updated title    body=updated body    userId=2
    ${response}=    PUT On Session    jsonplaceholder    ${resource}/2    json=${data}
    Should Be Equal As Integers    ${response.status_code}    200
