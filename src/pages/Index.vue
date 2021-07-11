<template>
  <div
    class="row items-center justify-center q-my-xl"
  >
    <div
      class="col-xs-10 col-md-8"
    >
      <q-card
        class="bg-grey-1 q-mb-lg"
      >
        <q-card-section>
          <q-tabs
            v-model="state.tab"
            align="justify"
            content-class="text-primary"
            dense
            narrow-indicator
            no-caps
          >
            <q-tab
              name="link"
              icon="link"
              label="Link"
            />
            <q-tab
              name="file"
              icon="attachment"
              label="File"
            />
          </q-tabs>
          <q-form
            @submit="storeLink"
          >
            <q-tab-panels
              v-model="state.tab"
            >
              <q-tab-panel
                class="bg-grey-1 q-px-none"
                name="link"
              >
                <q-input
                  ref="source"
                  v-model="state.source"
                  autofocus
                  input-class="text-body1 text-primary"
                  outlined
                >
                  <template
                    #prepend
                  >
                    <q-icon
                      name="link"
                    />
                  </template>
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
                      type="submit"
                      @click="storeLink"
                    />
                  </template>
                </q-input>
              </q-tab-panel>
              <q-tab-panel
                class="bg-grey-1 q-px-none"
                name="file"
              >
                <q-file
                  v-model="state.file"
                  :readonly="state.loading"
                  autofocus
                  input-class="text-body1 text-primary"
                  outlined
                >
                  <template
                    #prepend
                  >
                    <q-icon
                      name="attachment"
                    />
                  </template>
                  <template
                    #after
                  >
                    <q-btn
                      :loading="state.loading"
                      class="text-weight-light"
                      color="primary"
                      label="Upload"
                      no-caps
                      size="lg"
                      style="width: 100px"
                      @click="storeObject"
                    />
                  </template>
                </q-file>
              </q-tab-panel>
            </q-tab-panels>
          </q-form>
        </q-card-section>
      </q-card>
      <q-card>
        <q-list>
          <template
            v-for="(record, i) in state.records"
            :key="record.code"
          >
            <q-item
              class="bg-grey-1"
            >
              <q-item-section
                class="q-py-md"
              >
                <div
                  class="row"
                >
                  <div
                    class="col-xs-12 col-md-6 flex items-center q-pr-md-md"
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
                    class="col-xs-12 col-md-4 flex items-center"
                  >
                    <q-item-label
                      class="text-body1 text-weight-light q-mb-xs-lg q-mb-md-none"
                      style="word-break: break-all;"
                    >
                      <a
                        :href="`${redirectUrl}/${record.code}`"
                        class="text-primary"
                        rel="noopener noreferrer"
                        style="text-decoration: none;"
                        target="_blank"
                        v-text="`${redirectUrl}/${record.code}`"
                      />
                    </q-item-label>
                  </div>
                  <div
                    class="col-xs-12 col-md-2 flex items-center justify-xs-start justify-md-end"
                  >
                    <div class="flex no-wrap">
                      <q-btn
                        :color="`${isCopied(record) ? 'accent' : 'primary'}`"
                        flat
                        icon="content_copy"
                        round
                        @click="copyLink(record)"
                      />
                      <q-btn
                        color="primary"
                        flat
                        icon="delete_outline"
                        round
                        @click="destroyLink(record)"
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
  v4 as uuidv4,
} from 'uuid';
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
  ref,
  watch,
} from 'vue';

export default defineComponent({
  name: 'PageIndex',
  setup() {
    const $q = useQuasar();
    const redirectUrl = process.env.API_URL;
    const state = reactive({
      tab: 'link',
      loading: false,
      copied: '',
      source: '',
      records: [],
      file: null,
    });
    const source = ref(null);
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
    const storeLink = async () => {
      if (!isValidSource.value) {
        $q.notify({
          color: 'accent',
          message: 'Please provide a valid URL',
          timeout: 500,
        });
        return;
      }
      try {
        const { data } = await api.post('/links', {
          source: state.source.trim(),
          key: uuidv4(),
        });
        state.source = '';
        state.records = [data.data, ...state.records];
      } catch (err) {
        console.debug(err);
      }
      source.value.focus();
    };
    const copyLink = async (record) => {
      try {
        await copyToClipboard(`${redirectUrl}/${record.code}`);
        record.copied = true;
        setTimeout(() => delete record.copied, 1000);
      } catch (err) {
        console.debug(err);
      }
    };
    const destroyLink = async (record) => {
      try {
        await api.delete(`/links/${record.code}`, {
          params: {
            key: record.key,
          },
        });
      } catch (err) {
        console.debug(err);
      }
      state.records = state.records.filter((r) => r.code !== record.code);
    };
    const storeObject = async () => {
      if (!state.file) {
        $q.notify({
          color: 'accent',
          message: 'Please provide a valid file',
          timeout: 500,
        });
        return;
      }
      state.loading = true;
      const formData = new FormData();
      formData.append('files[]', state.file);
      formData.append('key', uuidv4().replaceAll('-', ''));
      try {
        const { data } = await api.post('/objects', formData, {
          headers: {
            'Content-Type': 'multipart/form-data',
          },
        });
        state.records = [{ ...data.data, source: state.file.name }, ...state.records];
        state.file = null;
        state.loading = false;
      } catch (err) {
        console.debug(err);
      }
    };
    return {
      redirectUrl,
      state,
      source,
      isValidSource,
      isCopied,
      storeLink,
      copyLink,
      destroyLink,
      storeObject,
    };
  },
});
</script>
