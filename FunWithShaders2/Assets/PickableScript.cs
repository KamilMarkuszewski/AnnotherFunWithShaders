using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;

namespace Assets
{
    public class PickableScript : MonoBehaviour
    {
        public Material PostEffectMaterialAfterPicking;

        public float SecondsOfShaderEffect;

        void OnTriggerEnter(Collider other)
        {
            if (PostEffectMaterialAfterPicking.HasProperty("_TimeStarted"))
            {
                PostEffectMaterialAfterPicking.SetFloat("_TimeStarted", Time.time);
            }

            PostEffectImage.SetShaderForSecs(PostEffectMaterialAfterPicking, SecondsOfShaderEffect);
        }

    }
}
