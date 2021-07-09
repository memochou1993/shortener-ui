<template>
  <div
    class="row items-center justify-center q-mt-xl"
  >
    <div
      class="col-xs-10 col-sm-8"
    >
      <q-card>
        <q-card-section>
          <q-form
            class="q-gutter-md"
          >
            <q-input
              v-model="source"
              input-class="text-body1 text-primary"
              outlined
              placeholder="URL"
            >
              <template
                #after
              >
                <q-btn
                  color="primary"
                  label="Shorten"
                  size="lg"
                />
              </template>
            </q-input>
          </q-form>
        </q-card-section>
      </q-card>
    </div>
  </div>
</template>

<script>
import {
  defineComponent,
  ref,
} from 'vue';

export default defineComponent({
  name: 'PageIndex',
  setup() {
    const source = ref('');
    return {
      source,
    };
  },
});
</script>
