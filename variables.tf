variable "access_key" {
  type = string
}

variable "secret_key" {
  type = string
}

variable "name" {
  type = string
}

/*
variable "record_name" {
     type = list(string)
}


variable "names" {
        type = map(object({
                {
            "a.abc.com"  = {
              record_name = "a"
                }
            "b.def.com"  = {
              record_name   = "b"
                }
        }))
}
*/
  variable "names" {
        type = map(object({
               host = string
        }))
}
