resource "aws_lex_bot" "example" {
  name             = local.lex_bot_name
  child_directed   = false
  process_behavior = "BUILD"
  enable_model_improvements = true  #Regional changes

  intent {
    intent_name    = aws_lex_intent.example.name
    intent_version = aws_lex_intent.example.version
  }

  abort_statement {
    message {
      content      = "Sorry, I am not able to assist at this time."
      content_type = "PlainText"
    }
  }

  clarification_prompt {
    max_attempts = 2

    message {
      content      = "I didn't understand you, what would you like to do?"
      content_type = "PlainText"
    }
  }
}

resource "aws_lex_intent" "example" {
  name = "example"

  fulfillment_activity {
    type = "ReturnIntent"
  }

  sample_utterances = [
    "example one",
    "example two"
  ]
}

resource "aws_lex_bot_alias" "lex_bot_alias" {
  bot_name    = aws_lex_bot.example.name
  bot_version = aws_lex_bot.example.version
  description = "${var.base_name} Lex Bot"
  name        = var.base_name
}


resource "aws_connect_bot_association" "lex_bot_association" {
  instance_id   = aws_connect_instance.POC.id
  lex_bot {
    name     = aws_lex_bot.example.name
    lex_region = var.region
  }
}