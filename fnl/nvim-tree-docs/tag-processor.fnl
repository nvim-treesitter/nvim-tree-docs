(module nvim-tree-docs.tag-processor
  {require {core aniseed.core}})

(defn- iterate [tag-ps context]
  (let [i 1]
    (fn []
      (let [tag (. tag-ps.tags i)
            processor (when tag
                        (or (. processors tag) default-processor))]
        (if (and tag processor)
          {:lines (processor context tag) : tag}
          nil)))))

(defn- to-lines [tag-ps context]
  (let [lines {}]
    (each [processed (iterate tag-ps context)]
      (tset lines processed.tag processed.lines))
    lines))

(defn new [processors tag-config]
  (let [tags (let [res []]
               (each [tag included (pairs tag-config)]
                 (when included
                   (table.insert res tag)))
               res)
        default-processor processors.__default
        tag-ps {: tags
                : default-processor}]
    (set tag-ps.iterate (partial iterate tag-ps))
    (set tag-ps.to-lines (partian iterate tag-ps))
    tag-ps))
