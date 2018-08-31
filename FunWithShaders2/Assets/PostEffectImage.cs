using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using UnityEngine;

namespace Assets
{
    [ExecuteInEditMode]
    public class PostEffectImage : MonoBehaviour
    {
        public Material PostEffectMaterial;
        public Material DefaultMaterial;

        private float _defautShaderShouldBeRestored = 0f;

        #region MonoBehaviour impl

        void OnRenderImage(RenderTexture src, RenderTexture dst)
        {
            Graphics.Blit(src, dst, PostEffectMaterial);
        }

        private void Start()
        {
            RestoreDefaultShader();
        }

        private void Update()
        {
            if (Time.time > _defautShaderShouldBeRestored)
            {
                RestoreDefaultShader();
            }
        }

        #endregion

        public static void SetShaderForSecs(Material mat, float time)
        {
            var camObj = GameObject.Find("MainCamera");
            var postEffectImage = camObj.GetComponent<PostEffectImage>();

            postEffectImage.SetShaderForSecsEx(mat, time, postEffectImage);
        }

        private void SetShaderForSecsEx(Material mat, float time, PostEffectImage component)
        {
            if (mat != null)
            {
                component.PostEffectMaterial = mat;
                _defautShaderShouldBeRestored = Time.fixedTime + time;
            }
        }

        private void RestoreDefaultShader()
        {
            PostEffectMaterial = DefaultMaterial;
        }
    }
}
