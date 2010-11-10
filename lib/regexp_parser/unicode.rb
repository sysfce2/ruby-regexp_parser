module Regexp::Scanner
  module Unicode

    # for \p{Age=4.0}, \P{age=5.2} Not in Ruby, yet. A patch has been
    # accepted, as experimental. This introduces a new twist to the
    # way the syntax specified, with ruby 1.9 <= 1.9.2 without it, and
    # possibly ruby 1.9.3 with. Anyway, the age property is available
    # in PERL, using the \p{Age: \d.\d} syntax with a spcial alias as
    # \p{Present_In: \d.\d}.
    Ages = [
      '1.1',
      '2.0',
      '2.1',
      '3.0',
      '3.1',
      '3.2',
      '4.0',
      '4.1',
      '5.0',
      '5.1',
      '5.2',
      '6.0',
    ].freeze

    module DerivedProperties
      Core = [
        'Math',
        'Alphabetic',
        'Lowercase',
        'Uppercase',
        'ID_Start',
        'ID_Continue',
        'XID_Start',
        'XID_Continue',
        'Default_Ignorable_Code_Point',
        'Grapheme_Base',
        'Grapheme_Extend',
      ].freeze

      Normalization = [
        'FNC',
        'Comp_Ex',
        'NFD_QuickCheck',
        'NFKD_QuickCheck',
        'NFC_QuickCheck',
        'NFKC_QuickCheck',
        'NFC_Expands',
        'NFD_Expands',
        'NFKC_Expands',
        'NFKD_Expands',
      ].freeze
    end

    Scripts = [
      'Arab', 'Arabic',
      'Armi', 'Imperial Aramaic',
      'Armn', 'Armenian',
      'Avst', 'Avestan',
      'Bali', 'Balinese',
      'Bamu', 'Bamum',
      'Beng', 'Bengali',
      'Bopo', 'Bopomofo',
      'Brai', 'Braille',
      'Bugi', 'Buginese',
      'Buhd', 'Buhid',
      'Cans', 'Canadian Aboriginal',
      'Cari', 'Carian',
      'Cham', 
      'Cher', 'Cherokee',
      'Copt', 'Coptic', 'Qaac',
      'Cprt', 'Cypriot',
      'Cyrl', 'Cyrillic',
      'Deva', 'Devanagari',
      'Dsrt', 'Deseret',
      'Egyp', 'Egyptian Hieroglyphs',
      'Ethi', 'Ethiopic',
      'Geor', 'Georgian',
      'Glag', 'Glagolitic',
      'Goth', 'Gothic',
      'Grek', 'Greek',
      'Gujr', 'Gujarati',
      'Guru', 'Gurmukhi',
      'Hang', 'Hangul',
      'Hani', 'Han',
      'Hano', 'Hanunoo',
      'Hebr', 'Hebrew',
      'Hira', 'Hiragana',
      'Hrkt', 'Katakana or Hiragana'
      'Ital', 'Old Italic',
      'Java', 'Javanese',
      'Kali', 'Kayah Li',
      'Kana', 'Katakana',
      'Khar', 'Kharoshthi',
      'Khmr', 'Khmer',
      'Knda', 'Kannada',
      'Kthi', 'Kaithi',
      'Lana', 'Tai Tham',
      'Laoo', 'Lao',
      'Latn', 'Latin',
      'Lepc', 'Lepcha',
      'Limb', 'Limbu',
      'Linb', 'Linear B',
      'Lisu', 'Lisu',
      'Lyci', 'Lycian',
      'Lydi', 'Lydian',
      'Mlym', 'Malayalam',
      'Mong', 'Mongolian',
      'Mtei', 'Meetei Mayek',
      'Mymr', 'Myanmar',
      'Nkoo', 'Nko',
      'Ogam', 'Ogham',
      'Olck', 'Ol Chiki',
      'Orkh', 'Old Turkic',
      'Orya', 'Oriya',
      'Osma', 'Osmanya',
      'Phag', 'Phags Pa',
      'Phli', 'Inscriptional Pahlavi',
      'Phnx', 'Phoenician',
      'Prti', 'Inscriptional Parthian',
      'Rjng', 'Rejang',
      'Runr', 'Runic',
      'Samr', 'Samaritan',
      'Sarb', 'Old South Arabian',
      'Saur', 'Saurashtra',
      'Shaw', 'Shavian',
      'Sinh', 'Sinhala',
      'Sund', 'Sundanese',
      'Sylo', 'Syloti Nagri',
      'Syrc', 'Syriac',
      'Tagb', 'Tagbanwa',
      'Tale', 'Tai Le',
      'Talu', 'New Tai Lue',
      'Taml', 'Tamil',
      'Tavt', 'Tai Viet',
      'Telu', 'Telugu',
      'Tfng', 'Tifinagh',
      'Tglg', 'Tagalog',
      'Thaa', 'Thaana',
      'Thai', 
      'Tibt', 'Tibetan',
      'Ugar', 'Ugaritic',
      'Vaii', 'Vai',
      'Xpeo', 'Old Persian',
      'Xsux', 'Cuneiform',
      'Yiii', 'Yi',
      'Zinh', 'Inherited', 'Qaai',
      'Zyyy', 'Common',
      'Zzzz', 'Unknown',
    ].freeze

  end Unicode
end # module Regexp::Scanner
