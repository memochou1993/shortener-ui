<template>
  <div
    class="row items-center justify-center q-my-xl"
  >
    <div
      class="col-xs-10 col-md-8"
    >
      <q-card>
        <q-card-section>
          <q-input
            v-model="state.source"
            input-class="text-body1 text-primary"
            outlined
            placeholder="Shorten your link"
          >
            <template
              #after
            >
              <q-btn
                class="text-weight-light"
                color="primary"
                label="Shorten"
                no-caps
                size="lg"
                style="width: 100px"
                @click="shorten"
              />
            </template>
          </q-input>
        </q-card-section>
      </q-card>
      <q-card
        class="q-my-lg"
      >
        <q-list>
          <template
            v-for="(record, i) in state.records"
            :key="record.code"
          >
            <q-item>
              <q-item-section
                class="q-py-md"
              >
                <div
                  class="row"
                >
                  <div
                    class="col-xs-12 col-md-6 flex items-center"
                  >
                    <q-item-label
                      :style="`max-width: ${$q.screen.lt.md ? 75 : 50}vw`"
                      class="text-body1 text-weight-light q-mb-xs-lg q-mb-md-none ellipsis"
                    >
                      <span
                        v-text="record.source"
                      />
                    </q-item-label>
                  </div>
                  <div
                    class="col-xs-12 col-md-4 flex items-center justify-xs-start justify-md-end"
                  >
                    <q-item-label
                      class="text-body1 text-weight-light q-mb-xs-lg q-mb-md-none"
                      style="word-break: break-all;"
                    >
                      <a
                        :href="`${baseUrl}${record.code}`"
                        class="text-primary"
                        rel="noopener noreferrer"
                        style="text-decoration: none;"
                        target="_blank"
                        v-text="`${baseUrl}${record.code}`"
                      />
                    </q-item-label>
                  </div>
                  <div
                    class="col-xs-12 col-md-2 flex items-center justify-xs-start justify-md-end"
                  >
                    <div class="flex no-wrap">
                      <q-btn
                        :color="`${isCopied(record) ? 'secondary' : 'primary'}`"
                        flat
                        icon="content_copy"
                        round
                        @click="copy(record)"
                      />
                      <q-btn
                        color="primary"
                        flat
                        icon="delete_outline"
                        round
                        @click="destroy(record)"
                      />
                    </div>
                  </div>
                </div>
              </q-item-section>
            </q-item>
            <q-separator
              v-show="i < state.records.length - 1"
            />
          </template>
        </q-list>
      </q-card>
    </div>
  </div>
</template>

<script>
import {
  useQuasar,
  copyToClipboard,
} from 'quasar';
import {
  api,
} from 'boot/axios';
import {
  computed,
  defineComponent,
  onMounted,
  reactive,
  watch,
} from 'vue';

export default defineComponent({
  name: 'PageIndex',
  setup() {
    const $q = useQuasar();
    const baseUrl = 'https://url.epoch.tw/';
    const state = reactive({
      copied: '',
      source: '',
      records: [],
    });
    onMounted(() => {
      state.records = JSON.parse(localStorage.getItem('records')) || [];
    });
    watch(() => state.records, () => {
      localStorage.setItem('records', JSON.stringify(state.records));
    });
    const isValidSource = computed(() => {
      let url;
      try {
        url = new URL(state.source);
      } catch {
        return false;
      }
      return url.protocol === 'http:' || url.protocol === 'https:';
    });
    const isCopied = (record) => record.copied;
    const shorten = async () => {
      if (!isValidSource.value) {
        $q.notify({
          color: 'pink',
          message: 'Please provide a valid URL',
          timeout: 500,
        });
        return;
      }
      try {
        const { data } = await api.post('/api/links', {
          source: state.source,
        });
        state.source = '';
        state.records = [data.data, ...state.records];
      } catch (err) {
        console.debug(err);
      }
    };
    const copy = async (record) => {
      try {
        await copyToClipboard(`${baseUrl}${record.code}`);
        record.copied = true;
        setTimeout(() => delete record.copied, 1000);
      } catch (err) {
        console.debug(err);
      }
    };
    const destroy = async (record) => {
      try {
        await api.delete(`/api/links/${record.code}`, {
          source: state.source,
        });
      } catch (err) {
        console.debug(err);
      }
      state.records = state.records.filter((r) => r.code !== record.code);
    };
    return {
      baseUrl,
      state,
      isValidSource,
      isCopied,
      shorten,
      copy,
      destroy,
    };
  },
});
</script>
