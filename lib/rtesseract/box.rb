# encoding: UTF-8
class RTesseract
  # Class to read char positions from an image
  class Box < RTesseract
    def initialize(src = '', options = {})
      @options = command_line_options(options)
      @value, @x, @y, @w, @h = [[]]
      @processor = RTesseract.choose_processor!(@processor)
      @source = @processor.image?(src) ? src : Pathname.new(src)
    end

    def characters
      convert if @value == []
      @value
    end

    def text_file
      @text_file = Pathname.new(Dir.tmpdir).join("#{Time.now.to_f}#{rand(1500)}.box").to_s
    end

    def config
      @options ||= {}
      @options.map { |k, v| "#{k} #{v}" }.join("\n")
    end

    def convert_text(text)
      text_objects = []
      text.each_line do |line|
        char, x_start, y_start, x_end, y_end, word = line.split(" ")
        text_objects << {:char => char, :x_start => x_start.to_i, :y_start => y_start.to_i , :x_end => x_end.to_i, :y_end => y_end.to_i}
      end
      @value = text_objects
    end

    # Convert image to string
    def convert
      @options ||= {}
      @options['tessedit_create_boxfile'] = 1
      @options['tessedit_write_images'] = 1

      # @options['ambigs_debug_level'] = 0
      # @options['applybox_debug'] = 1
      # @options['applybox_exposure_pattern'] = '.exp'
      # @options['applybox_learn_chars_and_char_frags_mode'] = 0
      # @options['applybox_learn_ngrams_mode'] = 0
      # @options['assume_fixed_pitch_char_segment'] = 0
      # @options['enable_new_segsearch'] = 0
      # @options['fixsp_done_mode'] = 1
      # @options['fixsp_non_noise_limit'] = 1
      # @options['force_word_assoc'] = 0
      # @options['fragments_debug'] = 0
      # @options['fragments_guide_chopper'] = 0
      # @options['heuristic_weight_rating'] = 1
      # @options['heuristic_weight_seamcut'] = 0
      # @options['interactive_display_mode'] = 0

      # @options['matcher_debug_flags'] = 0
      # @options['matcher_debug_level'] = 0
      # @options['matcher_debug_separate_windows'] = 0
      # @options['matcher_great_threshold'] = 0
      # @options['matcher_permanent_classes_min'] = 1
      # @options['merge_fragments_in_matrix'] = 1
      # @options['ngram_permuter_activated'] = 0
      # @options['oldbl_corrfix'] = 1
      # @options['oldbl_xhfix'] = 0
      # @options['output_ambig_words_file'] =
      # @options['pageseg_devanagari_split_strategy'] = 0
      # @options['paragraph_debug_level'] = 0
      # @options['poly_wide_objects_better'] = 1
      # @options['prioritize_division'] = 0
      # @options['quality_min_initial_alphas_reqd'] = 2

      # @options['segsearch_debug_level'] = 0
      # @options['segsearch_max_futile_classifications'] = 10
      # @options['segsearch_max_pain_points'] = 2000
      # @options['tessedit_adapt_to_char_fragments'] = 1
      # @options['tessedit_adaption_debug'] = 0
      # @options['tessedit_ambigs_training'] = 0
      # @options['tessedit_bigram_debug'] = 0
      # @options['tessedit_consistent_reps'] = 1
#@options['tessedit_create_hocr'] = 1
      # @options['tessedit_debug_block_rejection'] = 0
      # @options['tessedit_debug_doc_rejection'] = 0
      # @options['tessedit_debug_quality_metrics'] = 0
      #@options['tessedit_display_outwords'] = 1
      # @options['tessedit_dont_blkrej_good_wds'] = 0
      # @options['tessedit_dont_rowrej_good_wds'] = 0
      # @options['tessedit_dump_choices'] = 1
      # @options['tessedit_dump_pageseg_images'] = 0
      # @options['tessedit_enable_bigram_correction'] = 1
      # @options['tessedit_fix_fuzzy_spaces'] = 1
      # @options['tessedit_fix_hyphens'] = 1
      # @options['tessedit_flip_0O'] = 1
      # @options['tessedit_good_quality_unrej'] = 1
      # @options['tessedit_init_config_only'] = 0
      # @options['tessedit_make_boxes_from_boxes'] = 0
      # @options['tessedit_matcher_log'] = 0
      # @options['tessedit_minimal_rej_pass1'] = 0
      # @options['tessedit_minimal_rejection'] = 0
      # @options['tessedit_override_permuter'] = 1
      # @options['tessedit_prefer_joined_punct'] = 0
      # @options['tessedit_preserve_blk_rej_perfect_wds'] = 1
      # @options['tessedit_preserve_min_wd_len'] = 2
      # @options['tessedit_preserve_row_rej_perfect_wds'] = 1
      # @options['tessedit_redo_xheight'] = 1
      # @options['tessedit_reject_bad_qual_wds'] = 1
      # @options['tessedit_reject_mode'] = 0
      # @options['tessedit_rejection_debug'] = 0
      # @options['tessedit_resegment_from_boxes'] = 0
      # @options['tessedit_resegment_from_line_boxes'] = 0
      # @options['tessedit_row_rej_good_docs'] = 1
      # @options['tessedit_single_match'] = 0
      # @options['tessedit_tess_adapt_to_rejmap'] = 0
      # @options['tessedit_tess_adaption_mode'] = 39
      # @options['tessedit_test_adaption'] = 0
      # @options['tessedit_test_adaption_mode'] = 3
      # @options['tessedit_train_from_boxes'] = 0
      # @options['tessedit_training_tess'] = 0
      # @options['tessedit_unrej_any_wd'] = 0
      # @options['tessedit_use_reject_spaces'] = 1
      # @options['tessedit_write_unlv'] = 0
      # @options['tessedit_zero_kelvin_rejection'] = 0
      # @options['tessedit_zero_rejection'] = 0
      # @options['textord_all_prop'] = 0
      # @options['textord_balance_factor'] = 1
      # @options['textord_biased_skewcalc'] = 1
      # @options['textord_blockndoc_fixed'] = 0
      # @options['textord_blocksall_fixed'] = 0
      # @options['textord_blocksall_prop'] = 0
      # @options['textord_blocksall_testing'] = 0
      # @options['textord_chopper_test'] = 0
      # @options['textord_dump_table_images'] = 0
      # @options['textord_equation_detect'] = 0
      # @options['textord_expansion_factor'] = 1
      # @options['textord_fast_pitch_test'] = 0
      # @options['textord_fix_makerow_bug'] = 1
      # @options['textord_fix_xheight_bug'] = 1
      # @options['textord_force_make_prop_words'] = 0
      # @options['textord_fp_chopping'] = 1
      # @options['textord_heavy_nr'] = 0
      # @options['textord_interpolating_skew'] = 1
      # @options['textord_new_initial_xheight'] = 1
      # @options['textord_no_rejects'] = 0
      # @options['textord_noise_debug'] = 0
      # @options['textord_noise_rejrows'] = 1
      # @options['textord_noise_rejwords'] = 1
      # @options['textord_ocropus_mode'] = 0
      # @options['textord_old_baselines'] = 1
      # @options['textord_old_xheight'] = 0
      # @options['textord_oldbl_debug'] = 0
      # @options['textord_oldbl_merge_parts'] = 1
      # @options['textord_oldbl_paradef'] = 1
      # @options['textord_oldbl_split_splines'] = 1
      # @options['textord_parallel_baselines'] = 1
      # @options['textord_really_old_xheight'] = 0
      # @options['textord_restore_underlines'] = 1
      # @options['textord_show_expanded_rows'] = 0
      # @options['textord_show_final_blobs'] = 0
      # @options['textord_show_final_rows'] = 0
      # @options['textord_show_fixed_cuts'] = 0
      # @options['textord_show_initial_rows'] = 0
      # @options['textord_show_page_cuts'] = 0
      # @options['textord_show_parallel_rows'] = 0
      # @options['textord_show_row_cuts'] = 0
      # @options['textord_space_size_is_variable'] = 0
      # @options['textord_straight_baselines'] = 0
      # @options['textord_tabfind_find_tables'] = 1
      # @options['textord_tabfind_force_vertical_text'] = 0
      # @options['textord_tabfind_only_strokewidths'] = 0
      # @options['textord_tabfind_show_blocks'] = 0
      # @options['textord_tabfind_show_color_fit'] = 0
      # @options['textord_tabfind_show_columns'] = 0
      # @options['textord_tabfind_show_finaltabs'] = 0
      # @options['textord_tabfind_show_images'] = 0
      # @options['textord_tabfind_show_initial_partitions'] = 0
      # @options['textord_tabfind_show_initialtabs'] = 0
      # @options['textord_tabfind_show_partitions'] = 0
      # @options['textord_tabfind_show_reject_blobs'] = 0
      # @options['textord_tabfind_show_strokewidths'] = 0
      # @options['textord_tabfind_show_vlines'] = 0
      # @options['textord_tabfind_vertical_horizontal_mix'] = 1
      # @options['textord_tabfind_vertical_text'] = 1
      # @options['textord_tablefind_recognize_tables'] = 0
      # @options['textord_tablefind_show_mark'] = 0
      # @options['textord_tablefind_show_stats'] = 0
      # @options['textord_test_landscape'] = 0
      # @options['textord_test_mode'] = 1


      # @options['wordrec_blob_pause'] = 0
      # @options['wordrec_debug_blamer'] = 0
      # @options['wordrec_debug_level'] = 0
      # @options['wordrec_display_all_blobs'] = 0
      #@options['wordrec_display_all_words'] = 1
      # @options['wordrec_display_segmentations'] = 0
      # @options['wordrec_display_splits'] = 0
      # @options['wordrec_enable_assoc'] = 1
      # @options['wordrec_no_block'] = 0
      # @options['wordrec_run_blamer'] = 0
      # @options['wordrec_worst_state'] = 1


      `#{@command} "#{image}" "#{text_file.gsub('.box','')}" #{lang} #{psm} #{config_file} #{clear_console_output}`
      convert_text(File.read(@text_file).to_s)
      remove_file([@image, @text_file])
    rescue => error
      raise RTesseract::ConversionError.new(error)
    end

    def source=(src)
      @value = []
      @source = @processor.image?(src) ? src : Pathname.new(src)
    end

    def self.read(src = nil, options = {}, &block)
      fail RTesseract::ImageNotSelectedError if src.nil?
      processor = RTesseract.choose_processor!(options.delete(:processor) || options.delete('processor'))
      image = processor.read_with_processor(src.to_s)

      yield image
      object = RTesseract.new('', options)
      object.from_blob(image.to_blob)
      object
    end


    # Crop image to convert
    def crop!(x, y, width, height)
      @value = []
      @x, @y, @w, @h = x.to_i, y.to_i, width.to_i, height.to_i
      self
    end

    # Read image from memory blob
    def from_blob(blob)
      blob_file = Tempfile.new('blob')
      blob_file.write(blob)
      blob_file.rewind
      blob_file.flush
      self.source = blob_file.path
      convert
      remove_file([blob_file])
    rescue => error
      raise RTesseract::ConversionError.new(error)
    end

    # Output value
    def to_s
      return @value if @value != ''
      if @processor.image?(@source) || @source.file?
        convert
        @value
      else
        fail RTesseract::ImageNotSelectedError.new(@source)
      end
    end

  end
end
