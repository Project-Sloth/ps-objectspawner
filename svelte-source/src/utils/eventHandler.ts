import { onMount, onDestroy } from "svelte";
import ObjectStore from '../stores/objectStore';

interface nuiMessage {
  data: {
    action: string,
    [key: string]: any,
  },
}

export function EventHandler() {
  function handleEvents(event: nuiMessage) {
    switch (event.data.action) {
      case "open":
        ObjectStore.receiveOpenMessage();
        break;
      case "load":
        ObjectStore.receiveLoadMessage(event.data);
    }
  }

  onMount(() => window.addEventListener("message", handleEvents));
  onDestroy(() => window.removeEventListener("message", handleEvents));
}

export async function fetchNui(eventName: string, data: unknown = {}) {
  const options = {
    method: "post",
    headers: {
      "Content-Type": "application/json; charset=UTF-8",
    },
    body: JSON.stringify(data),
  };

  const resourceName: string = "ps-objectspawner";

  try {
    const resp = await fetch(`https://${resourceName}/${eventName}`, options);
    return await resp.json();
  } catch(err) {
  }
}