# author mike dalton
# date created august 14, 2009
# last modified august 17, 2009
# todo nothing, maybe make this a Utility class

class Convert
  # convert aminoacid sequence to hp model
  # returns a string
  # takes the string of amino acids, converts each of them to their equivalent hp value and returns that as a string
  def Convert.aatohp(seq)
    hp_seq = []
    seq.each_char { |aa| hp_seq.push((HYDROPHOBIC.index(aa)==nil) ? "p" : "h") }
    hp_seq.join
  end
end
