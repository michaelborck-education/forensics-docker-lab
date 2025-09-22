rule Lab1_Webshell_Pattern
{
    meta:
        author = "Instructor"
        description = "Simple pattern for suspicious eval usage"
    strings:
        $a = "base64_decode(" ascii
        $b = "eval(" ascii
        $c = /\$_(GET|POST|REQUEST)\[/
    condition:
        2 of them
}
