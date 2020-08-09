#include <mruby.h>

#include <mruby/require/require.h>

#include "compiled_features.h"

void
mrb_mruby_test_bench_gem_init(mrb_state* mrb) {
  mrb_register_compiled_features(
    mrb,
    mrb_mruby_test_bench_compiled_features,
    mrb_mruby_test_bench_compiled_features_count
  );

  return;
}

void
mrb_mruby_test_bench_gem_final(mrb_state* mrb) {
  return;
}
