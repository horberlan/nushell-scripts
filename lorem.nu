# gen a lorem text
def lorem [
  word_count: int = 50 # Number of words to generate.
  line_width_ratio: float = 1.0 # Normalized width that each line should fit to.
] {
    let lorem_words = [
        "lorem" "ipsum" "dolor" "sit" "amet" "consectetur" "adipiscing" "elit"
        "sed" "do" "eiusmod" "tempor" "incididunt" "ut" "labore" "et" "dolore"
        "magna" "aliqua" "enim" "ad" "minim" "veniam" "quis" "nostrud"
        "exercitation" "ullamco" "laboris" "nisi" "ut" "aliquip" "ex" "ea"
        "commodo" "consequat" "duis" "aute" "irure" "dolor" "in" "reprehenderit"
        "voluptate" "velit" "esse" "cillum" "eu" "fugiat" "nulla" "pariatur"
    ]

    let terminal_width = (term size).columns
    let target_line_width = terminal_width * $line_width_ratio

    let generated_words = (0..$word_count | each { |_| 
        $lorem_words | get (random int 0..($lorem_words | length | $in - 1))
    })

    let formatted_lines = ($generated_words | reduce -f [] { |word, acc|
        let current_line = if ($acc | is-empty) {
          ""
          } else {
            $acc | last 
        }
        let new_line = if ($current_line | is-empty) {
            [$word]
        } else {
            let test_line = ($current_line | append $word | str join " ")
            if ($test_line | str length) > $target_line_width {
                $acc | append [$word]
            } else {
                let acc_without_last = ($acc | range ..-2)
                $acc_without_last | append [($current_line | append $word)]
            }
        }
        $new_line
    })
    $formatted_lines | each { |line| $line | str join " " } | str join "\n"
}